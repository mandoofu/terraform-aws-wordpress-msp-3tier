#!/bin/bash
set -euxo pipefail

# Terraform 에서 넘겨준 값으로 쉘 변수 초기화
DB_NAME="${db_name}"
DB_USER="${db_user}"
DB_PASSWORD="${db_password}"
DB_HOST="${db_host}"
EFS_ID="${efs_file_system_id}"

dnf -y update
dnf -y install httpd php php-mysqlnd php-fpm mariadb105 amazon-efs-utils wget tar

systemctl enable httpd
systemctl start httpd

cd /var/www/html
rm -rf ./*

wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz

mkdir -p /var/www/html/wp-content

# EFS 마운트
echo "$EFS_ID:/ /var/www/html/wp-content efs defaults,_netdev 0 0" >> /etc/fstab
mount -a || true

chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# wp-config.php 생성
cat > /var/www/html/wp-config.php <<EOF
<?php
define( 'DB_NAME', '$DB_NAME' );
define( 'DB_USER', '$DB_USER' );
define( 'DB_PASSWORD', '$DB_PASSWORD' );
define( 'DB_HOST', '$DB_HOST' );
define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', '' );
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
  \$_SERVER['HTTPS'] = 'on';
}
define( 'FS_METHOD', 'direct' );
if ( !defined('ABSPATH') ) define('ABSPATH', __DIR__ . '/');
require_once ABSPATH . 'wp-settings.php';
EOF

chown apache:apache /var/www/html/wp-config.php

echo "OK" > /var/www/html/healthz.html
chown apache:apache /var/www/html/healthz.html

systemctl restart httpd
