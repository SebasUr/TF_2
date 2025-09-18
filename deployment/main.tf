module "network" {
  source              = "./modules/network"
  vpc_cidr            = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  create_nat_gateways = var.create_nat_gateways
}

module "security" {
  source               = "./modules/security"
  vpc_id               = module.network.vpc_id
  public_subnet_cidrs  = module.network.public_subnet_cidrs
  private_subnet_cidrs = module.network.private_subnet_cidrs
  backend_port         = 5001
}

module "compute" {
  source                = "./modules/compute"
  bastion_ami           = var.bastion_ami
  instance_type_bastion = var.instance_type_bastion
  public_subnet_id      = module.network.public_subnet_ids[0]
  key_name              = var.key_name
  sg_bastion_id         = module.security.sg_bastion_id
}

module "alb" {
  source                     = "./modules/alb"
  public_subnet_ids          = module.network.public_subnet_ids
  sg_lb_id                   = module.security.sg_lb_id
  vpc_id                     = module.network.vpc_id
  frontend_health_check_path = "/"
  backend_health_check_path  = "/api/health"
  backend_port               = 5001
  api_path                   = "/api/*"
}

locals {
  alb_dns      = module.alb.alb_dns_name
  api_base_url = "http://${local.alb_dns}/api"

  frontend_user_data_script = <<-EOT
    #!/bin/bash
    set -xe
    export DEBIAN_FRONTEND=noninteractive
    export AWS_REGION="${var.region}"
    export AWS_DEFAULT_REGION="${var.region}"
    export VITE_API_BASE_URL="${local.api_base_url}"

    apt-get update -y
    apt-get install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release \
      software-properties-common

    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update -y

    apt-get install -y \
      docker-ce \
      docker-ce-cli \
      containerd.io \
      docker-buildx-plugin \
      docker-compose-plugin

    # Habilitar e iniciar docker
    systemctl enable --now docker

    # Añadir usuario ubuntu al grupo docker si existe
    if id ubuntu >/dev/null 2>&1; then
      usermod -aG docker ubuntu
    fi

    # Clone repo and run only frontend service
    mkdir -p /opt/app && cd /opt/app
    if [ ! -d repo ]; then
      git clone "${var.repo_url}" repo || true
    fi
    cd repo

    # Pull/build and start only frontend2
    docker compose pull || true
    docker compose build --build-arg VITE_API_BASE_URL="${local.api_base_url}" frontend2 || true
    docker compose up -d frontend2
  EOT

  backend_user_data_script = <<-EOT
    #!/bin/bash
    set -xe
    export DEBIAN_FRONTEND=noninteractive
    export AWS_REGION="${var.region}"
    export AWS_DEFAULT_REGION="${var.region}"
    export AWS_ACCESS_KEY_ID="${var.aws_access_key_id}"
    export AWS_SECRET_ACCESS_KEY="${var.aws_secret_access_key}"
    export AWS_SESSION_TOKEN="${var.aws_session_token}"

    # Persist env vars for future sessions
    echo "AWS_ACCESS_KEY_ID=${var.aws_access_key_id}" >> /etc/environment
    echo "AWS_SECRET_ACCESS_KEY=${var.aws_secret_access_key}" >> /etc/environment
    echo "AWS_SESSION_TOKEN=${var.aws_session_token}" >> /etc/environment

    apt-get update -y
    apt-get install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release \
      software-properties-common

    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update -y

    apt-get install -y \
      docker-ce \
      docker-ce-cli \
      containerd.io \
      docker-buildx-plugin \
      docker-compose-plugin

    # Habilitar e iniciar docker
    systemctl enable --now docker

    # Añadir usuario ubuntu al grupo docker si existe
    if id ubuntu >/dev/null 2>&1; then
      usermod -aG docker ubuntu
    fi

    mkdir -p /opt/app && cd /opt/app
    if [ ! -d repo ]; then
      git clone "${var.repo_url}" repo || true
    fi
    cd repo

    docker compose pull || true
    docker compose build backend || true
    docker compose up -d backend
    docker compose exec -e AWS_ACCESS_KEY_ID="${var.aws_access_key_id}" -e AWS_SECRET_ACCESS_KEY="${var.aws_secret_access_key}" -e AWS_SESSION_TOKEN="${var.aws_session_token}" backend npm run seeder
  EOT
}

locals {
  frontend_private_subnets = [
    module.network.private_subnets_by_cidr["172.16.2.0/24"],
    module.network.private_subnets_by_cidr["172.16.5.0/24"],
  ]
  backend_private_subnets = [
    module.network.private_subnets_by_cidr["172.16.3.0/24"],
    module.network.private_subnets_by_cidr["172.16.6.0/24"],
  ]
}

# Frontend Auto Scaling Group
module "autoscaling_frontend" {
  source              = "./modules/autoscaling"
  private_subnet_ids  = local.frontend_private_subnets
  launch_template_ami = var.web_ami
  instance_type       = var.web_instance_type
  sg_web_id           = module.security.sg_frontend_id
  key_name            = var.key_name
  target_group_arn    = module.alb.frontend_target_group_arn
  desired_capacity    = var.web_desired
  min_size            = var.web_min
  max_size            = var.web_max
  # Optionally pass user_data to start nginx serving your static build
  user_data      = local.frontend_user_data_script
  asg_name       = "frontend-asg"
  lt_name_prefix = "frontend-lt-"
}

# Backend Auto Scaling Group
module "autoscaling_backend" {
  source              = "./modules/autoscaling"
  private_subnet_ids  = local.backend_private_subnets
  launch_template_ami = var.web_ami
  instance_type       = var.web_instance_type
  sg_web_id           = module.security.sg_backend_id
  key_name            = var.key_name
  target_group_arn    = module.alb.backend_target_group_arn
  desired_capacity    = var.web_desired
  min_size            = var.web_min
  max_size            = var.web_max
  user_data           = local.backend_user_data_script
  asg_name            = "backend-asg"
  lt_name_prefix      = "backend-lt-"
}

module "dynamo" {
  source     = "./modules/dynamo"
  table_name = var.table_name
}
