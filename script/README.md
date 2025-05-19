# Script: `crear_usuario_ftp.sh`

Este script automatiza la creación de usuarios FTP en un servidor Linux, configurando permisos, bases de datos y directorios específicos para cada usuario nuevo.

## 🚀 Características

- Crea usuarios FTP con un nombre secuencial (`usuarioXX`).
- Genera una contraseña aleatoria para el nuevo usuario.
- Configura directorios personales (`public_html`, `uploads`).
- Asigna permisos y propiedad a los directorios creados.
- Crea una base de datos para cada usuario con sus respectivas credenciales.
- Guarda las credenciales de acceso en un archivo de configuración (`db_credentials.php`).
- Agrega los usuarios al grupo `ftpusers` para gestionar el acceso FTP.
- Configura un archivo de bienvenida en el directorio web (`info.php`).
- Integra el usuario en el sistema `vsftpd`.

## 📋 Requisitos

Antes de ejecutar el script, asegúrate de contar con:

- Un servidor Linux con `vsftpd` instalado.
- Acceso con permisos de `sudo`.
- MySQL o MariaDB instalado y configurado.
- Servidor web (`Apache`/`Nginx` recomendado).
- `openssl` para generar contraseñas aleatorias.

## 🛠️ Instalación

1. Clona el repositorio en tu servidor:
   git clone https://github.com/Alejo101HD/Hosting-Automation-Scripts.git
   
2. Accede al directorio donde está el script:
   cd Hosting-Automation-Scripts/script
   
3. Asigna permisos de ejecución al script:
   chmod +x crear_usuario_ftp.sh
   
🚀 Uso
Ejecuta el script con:
sudo ./crear_usuario_ftp.sh

Una vez completado, verás en pantalla la información del usuario creado, incluyendo su contraseña y configuración FTP.

⚠️ Advertencias
Las credenciales generadas se guardan en texto plano. Asegúrate de proteger el acceso al directorio de credenciales (credenciales).

Revisar permisos de archivos y grupos. Modifica los permisos si es necesario para mantener la seguridad.

🖥️ Ejemplo de salida

#==============================
Usuario creado: usuario04
Contraseña: k4Jv9LpXqT5m
Directorio web: /home/usuario04/public_html
Base de datos: bd_usuario04
Usuario de base de datos: usuario04
Credenciales: /home/usuario04/credenciales/db_credentials.php
phpMyAdmin: http://<IP_SERVIDOR>/phpmyadmin
#==============================

📚 Información del Proyecto
Este script fue desarrollado como parte de un proyecto académico en la Universidad Politécnica Salesiana (UPS) - Quito, Ecuador, por:

   - Alejandro Coronel
   - David Cruz

✍️ Autoría y Uso
Este proyecto fue desarrollado con fines educativos y puede ser utilizado y modificado libremente. No cuenta con una licencia específica.
