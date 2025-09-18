# BookStore

El proyecto a desplegar en este laboratorio es una aplicación web. La aplicación permite visualizar una colección de recursos, para efectos de este caso, libros. Igualmente, cuando el usuario selecciona alguno de los recursos, se ofrece una vista con información detallada sobre el recurso seleccionado. La información de los recursos (libros) se encuentra almacenada en base de datos. La aplicación tiene tres (vistas): raíz (“/”, home), descripción detallada de los recursos libros y acerca de.

El proyecto tiene las siguientes carpetas
- frontend: Versión actualizada de paquetes del repositorio original del frontend, react
- frontend2: Versión actualizada de paquetes, react y estilos adicionales con VITE y shadcn 
- backend: Servidor backend con node.js /api, /api/books
- deployment: Toda la infraestructura como código de cada uno de los módulos, al ejecutar **terraform apply** en este directorio se montará y configurará toda la infraestructura. Dejando como output un loadbalancer al cual se puede acceder después de unos minutos de la configuración y se podrá observar el front y acceder a la api que provee el backend en esa misma url con terminación /api
- deploy_dynamo_test: Test para subir dynamodb. No utilizado en deployment
- deploy_s3_front: Deployment + copia de archivos a un bucket de S3 de los archivos estáticos después de ejcutar **npm run build** en el directorio frontend2. Para que funcione correctamente se debe buildear con la variable de entorno seteada en .env.production, VITE_API_BASE_URL (URL del backend). Al tirar **terraform apply**, una vez este ha sido terminado, se debe acceder a la consola para ir a la URL del bucket, y se podrá observar el frontend desde S3.

<img width="1179" height="812" alt="image" src="https://github.com/user-attachments/assets/c66fcd8e-853e-447b-830d-7fb94137c88f" />
