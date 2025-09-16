provider "aws" {
  region = var.region
  # Credentials are resolved by the default chain:
  # - EC2 instance profile / ECS task role
  # - Environment (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN)
  # - Shared config/credentials files (AWS_PROFILE)
}
