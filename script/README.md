# Script: `crear_usuario_ftp.sh`

Este script automatiza la creación de usuarios FTP en un sistema Linux, configurando permisos, bases de datos y directorios específicos para cada usuario nuevo.

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

   ```bash
   git clone https://github.com/tu_usuario/tu_repositorio.git
