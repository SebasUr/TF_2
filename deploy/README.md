# Deploy infraestructura (Terraform) y carga de datos

Este folder contiene IaC para crear la tabla DynamoDB y un script para poblarla.

## Requisitos
- Credenciales AWS en variables de entorno (temporales de AWS Academy funcionan):
  - AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN (si aplica)
  - AWS_REGION (debe coincidir con la región del laboratorio)
- Terraform >= 1.5
- Node.js (para el seeder)

## Crear la tabla DynamoDB
1. Ajusta variables si lo necesitas (por defecto crea `tb_books`):
   - `deploy/main.tf` variables `aws_region` y `table_name` o usa `-var` / `*.tfvars`
2. Inicializa y aplica:

```sh
terraform -chdir=deploy init
terraform -chdir=deploy apply -auto-approve
```

## Sembrar datos (seeder)
1. Desde la carpeta `backend`, instala dependencias si no lo has hecho y exporta las variables de entorno.
2. Ejecuta el seeder:

```sh
cd ../backend
npm run seeder
```

Esto hará escrituras en batch a la tabla `tb_books`.

## Notas
- La app backend espera la tabla `tb_books` con clave de partición `id` (tipo String).
- El campo `price` se maneja como string (p. ej. `$20.00`) para coincidir con el frontend.
