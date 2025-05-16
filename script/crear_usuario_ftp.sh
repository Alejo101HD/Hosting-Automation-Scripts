# Directorio base para los usuarios

BASE_DIR="/home"

FTP_USER_PREFIX="usuario"

HTML_DIR="public_html"

UPLOADS_DIR="uploads"

DB_PREFIX="bd_"

USERLIST_FILE="/etc/vsftpd.userlist"

FTP_GROUP="ftpusers"


# Crear grupo ftpusers si no existe

if ! getent group "$FTP_GROUP" > /dev/null; then

    echo "Creando grupo $FTP_GROUP..."

    sudo groupadd "$FTP_GROUP"

fi


# Contador para el nuevo usuario

USER_COUNT=$(ls $BASE_DIR | grep -E "^$FTP_USER_PREFIX[0-9]{2}$" | wc -l)

NEW_USER_NUM=$(printf "%02d" $((USER_COUNT + 1)))

NEW_USER="$FTP_USER_PREFIX$NEW_USER_NUM"


# Generar una contraseña aleatoria

PASSWORD=$(openssl rand -base64 12)


# Crear el usuario sin acceso SSH (-s /usr/sbin/nologin)

sudo useradd -m -d "$BASE_DIR/$NEW_USER" -s /usr/sbin/nologin "$NEW_USER"

echo "$NEW_USER:$PASSWORD" | sudo chpasswd


# Agregar al grupo ftpusers para acceso por FTP

sudo usermod -aG "$FTP_GROUP" "$NEW_USER"


# Verificar y crear directorios necesarios

sudo mkdir -p "$BASE_DIR/$NEW_USER/$HTML_DIR"

sudo mkdir -p "$BASE_DIR/$NEW_USER/$UPLOADS_DIR"


# Asignar permisos apropiados

sudo chmod 755 "$BASE_DIR/$NEW_USER"

sudo chmod 755 "$BASE_DIR/$NEW_USER/$UPLOADS_DIR"

sudo chown -R $NEW_USER:www-data "$BASE_DIR/$NEW_USER/$HTML_DIR"

sudo chown -R $NEW_USER:$NEW_USER "$BASE_DIR/$NEW_USER"


# Crear archivo info.php con mensaje de bienvenida y phpinfo

INFO_FILE="$BASE_DIR/$NEW_USER/$HTML_DIR/info.php"

cat <<EOF | sudo tee "$INFO_FILE" > /dev/null

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Bienvenido a Hosting31</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;600&display=swap');

  /* Reset & base */
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }

  body {
    font-family: 'Poppins', sans-serif;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
    color: #fff;
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    padding: 2rem;
  }

  .container {
    max-width: 900px;
    background: rgba(255, 255, 255, 0.07);
    border-radius: 20px;
    padding: 3rem 2rem;
    box-shadow: 0 0 25px rgba(255 255 255 / 0.15);
    backdrop-filter: blur(15px);
  }

  h1 {
    font-weight: 600;
    font-size: 3.5rem;
    margin-bottom: 0.5rem;
    letter-spacing: 2px;
    text-shadow: 0 0 10px #34e89e, 0 0 20px #0f2027;
  }

  h2 {
    font-weight: 300;
    font-size: 1.6rem;
    color: #a3d9d0;
    margin-bottom: 2rem;
  }

  /* Animated robot duck gif container */
  .animation-container {
    max-width: 400px;
    margin: 0 auto 3rem auto;
  }
  
  img.animation {
    width: 100%;
    border-radius: 15px;
    box-shadow: 0 0 20px #00ffe7;
    animation: pulse 4s ease-in-out infinite;
  }

  @keyframes pulse {
    0%, 100% {
      box-shadow: 0 0 20px #00ffe7;
      transform: scale(1);
    }
    50% {
      box-shadow: 0 0 40px #00fff0;
      transform: scale(1.05);
    }
  }

  /* Button with cool animation */
  .btn {
    display: inline-block;
    padding: 0.75rem 2.25rem;
    font-weight: 600;
    font-size: 1.2rem;
    color: #0f2027;
    background: #34e89e;
    border-radius: 35px;
    text-decoration: none;
    box-shadow: 0 8px 15px rgba(52, 232, 158, 0.4);
    transition: all 0.3s ease;
    cursor: pointer;
  }
  .btn:hover {
    background: #0f2027;
    color: #34e89e;
    box-shadow: 0 15px 20px rgba(52, 232, 158, 0.7);
    transform: translateY(-3px);
  }

  /* Footer with subtle animation */
  .footer {
    margin-top: 3rem;
    font-size: 0.85rem;
    color: #32d6aa99;
    letter-spacing: 1.5px;
    animation: glowText 6s ease-in-out infinite;
  }

  @keyframes glowText {
    0%, 100% {
      text-shadow: 0 0 4px #34e89e44;
      color: #32d6aa99;
    }
    50% {
      text-shadow: 0 0 16px #34e89e;
      color: #a0fff0cc;
    }
  }
</style>
</head>
<body>
  <div class="container" role="main">
    <h1>Bienvenid@ a Hosting31, $NEW_USER!</h1>
    <h2>Antes de subir lo que sea que quieras subir, mira este pato:</h2>
    <div class="animation-container" aria-label="Animated robot duck">
      <img 
        src="https://i.gifer.com/XOsX.gif" 
        alt="Animated robot duck floating with blinking lights" 
        class="animation" 
        loading="lazy"
      />
</body>
</html>
EOF

sudo chown $NEW_USER:$NEW_USER "$INFO_FILE"


# Crear la base de datos para el usuario

DB_NAME="${DB_PREFIX}${NEW_USER}"

sudo mysql -e "DROP DATABASE IF EXISTS $DB_NAME;"

sudo mysql -e "CREATE DATABASE $DB_NAME;"

sudo mysql -e "CREATE USER '$NEW_USER'@'%' IDENTIFIED BY '$PASSWORD';"

sudo mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON $DB_NAME.* TO '$NEW_USER'@'%';"

sudo mysql -e "FLUSH PRIVILEGES;"


# Crear carpeta de credenciales

CRED_DIR="$BASE_DIR/$NEW_USER/credenciales"

sudo mkdir -p "$CRED_DIR"


# Crear archivo con credenciales en PHP

CRED_FILE="$CRED_DIR/db_credentials.php"

cat <<EOPHP | sudo tee "$CRED_FILE" > /dev/null

<?php

// Credenciales de acceso a la base de datos

\$db_user = '$NEW_USER';

\$db_pass = '$PASSWORD';

\$db_name = '$DB_NAME';

\$db_host = 'localhost';

?>

EOPHP

sudo chown -R $NEW_USER:$NEW_USER "$CRED_DIR"

sudo chmod 700 "$CRED_DIR"

sudo chmod 600 "$CRED_FILE"


# Asegurar que el shell nologin esté en /etc/shells

grep -qxF '/usr/sbin/nologin' /etc/shells || echo '/usr/sbin/nologin' | sudo tee -a /etc/shells > /dev/null


# Agregar usuario al archivo vsftpd.userlist si no está

if ! grep -qxF "$NEW_USER" "$USERLIST_FILE"; then

    echo "$NEW_USER" | sudo tee -a "$USERLIST_FILE" > /dev/null

fi


# Mostrar credenciales y resumen

echo "=============================="

echo "Usuario creado: $NEW_USER"

echo "Contraseña: $PASSWORD"

echo "Directorio web: $BASE_DIR/$NEW_USER/$HTML_DIR"

echo "Base de datos: $DB_NAME"

echo "Usuario de base de datos: $NEW_USER"

echo "Credenciales: $CRED_FILE"

echo "phpMyAdmin: http://<IP_SERVIDOR>/phpmyadmin"

echo "=============================="
