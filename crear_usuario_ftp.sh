#!/bin/bash

# === CONFIGURACIÓN GENERAL ===
read -p "Ingresa el número del usuario (ej: 15 para usuario15): " num
usuario="usuario$num"
directorio_web="/var/www/$usuario"
db_user="$usuario"
db_name="$usuario"
ftp_pass=$(openssl rand -base64 12)
db_pass=$(openssl rand -base64 12)
info_file="$HOME/credenciales_$usuario.txt"

# === CREAR USUARIO DEL SISTEMA ===
sudo adduser --disabled-password --gecos "" "$usuario"

# === CREAR DIRECTORIO WEB PERSONAL ===
sudo mkdir -p "$directorio_web"
sudo chown "$usuario:$usuario" "$directorio_web"

# === CREAR BASE DE DATOS Y USUARIO EN MARIADB ===
sudo mariadb -e "CREATE DATABASE $db_name;"
sudo mariadb -e "CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_pass';"
sudo mariadb -e "GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';"
sudo mariadb -e "FLUSH PRIVILEGES;"

# === GUARDAR CREDENCIALES EN ARCHIVO ===
echo "==== CREDENCIALES DE HOSTING ====" > "$info_file"
echo "Usuario del sistema: $usuario" >> "$info_file"
echo "Contraseña FTP: $ftp_pass" >> "$info_file"
echo "Directorio web: $directorio_web" >> "$info_file"
echo "Base de datos: $db_name" >> "$info_file"
echo "Usuario DB: $db_user" >> "$info_file"
echo "Contraseña DB: $db_pass" >> "$info_file"

# === MOSTRAR RESUMEN ===
cat "$info_file"
