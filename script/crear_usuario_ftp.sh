#script/

# Directorio base para los usuarios
BASE_DIR="/home"
FTP_USER_PREFIX="usuario"
HTML_DIR="html_public"
UPLOADS_DIR="uploads"
DB_PREFIX="bd_"

# Contador para el nuevo usuario
USER_COUNT=$(ls $BASE_DIR | grep -E "^$FTP_USER_PREFIX[0-9]{2}$" | wc -l)
NEW_USER_NUM=$(printf "%02d" $((USER_COUNT + 1)))
NEW_USER="$FTP_USER_PREFIX$NEW_USER_NUM"

# Generar una contraseña aleatoria
PASSWORD=$(openssl rand -base64 12)

# Crear el usuario sin acceso SSH (-s /usr/sbin/nologin)
sudo useradd -m -d "$BASE_DIR/$NEW_USER" -s /usr/sbin/nologin "$NEW_USER"
echo "$NEW_USER:$PASSWORD" | sudo chpasswd

# Crear los directorios del usuario
mkdir -p "$BASE_DIR/$NEW_USER/$HTML_DIR"
mkdir -p "$BASE_DIR/$NEW_USER/$UPLOADS_DIR"

# Asignar permisos apropiados
sudo chmod 755 "$BASE_DIR/$NEW_USER"
sudo chmod 755 "$BASE_DIR/$NEW_USER/$UPLOADS_DIR"
sudo chown -R $NEW_USER:$NEW_USER "$BASE_DIR/$NEW_USER"

# Crear archivo info.php con mensaje de bienvenida y phpinfo
INFO_FILE="$BASE_DIR/$NEW_USER/$HTML_DIR/info.php"
cat <<EOF > "$INFO_FILE"
<!DOCTYPE html>
<html>
<head>
    <title>Bienvenido a Hosting31</title>
</head>
<body>
    <h1>¡Bienvenido a Hosting31, $NEW_USER!</h1>
    <p>Tu cuenta de hosting ha sido creada exitosamente.</p>
    <hr>
    <?php phpinfo(); ?>
</body>
</html>
EOF

# Cambiar el propietario del archivo
sudo chown $NEW_USER:$NEW_USER "$INFO_FILE"

# Crear la base de datos para el usuario
DB_NAME="${DB_PREFIX}${NEW_USER}"
sudo mysql -e "CREATE DATABASE $DB_NAME;"
sudo mysql -e "CREATE USER '$NEW_USER'@'localhost' IDENTIFIED BY '$PASSWORD';"
sudo mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON $DB_NAME.* TO '$NEW_USER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Mostrar credenciales y resumen
echo "=============================="
echo "Usuario creado: $NEW_USER"
echo "Contraseña: $PASSWORD"
echo "Directorio web: $BASE_DIR/$NEW_USER/$HTML_DIR"
echo "Base de datos: $DB_NAME"
echo "Usuario de base de datos: $NEW_USER"
echo "=============================="
