sed -i 's/PHP_PORT/'${PHP_PORT}'/g' /etc/php/7.3/fpm/pool.d/www.conf

if [ -f "/var/www/wordpress/wp-config.php" ]
then
  wp user update $WP_USER --user_pass=$WP_PASSWORD --allow-root
  echo "WordPress already configured."
else
  wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
  wp core download --path=$WP_PATH --allow-root
  wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --path=$WP_PATH --skip-check --allow-root
  if [ $? -ne 0 ]; then
    echo "wp-config.php creation"
    cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
    sed -i "s/database_name_here/$MYSQL_DATABASE/" /var/www/wordpress/wp-config.php
    sed -i "s/username_here/$MYSQL_USER/" /var/www/wordpress/wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/" /var/www/wordpress/wp-config.php
    sed -i "s/localhost/mariadb/" /var/www/wordpress/wp-config.php
  fi
  wp core install --path=$WP_PATH --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_USER --admin_password=$WP_PASSWORD --admin_email=$WP_EMAIL --skip-email --allow-root
  
  wp theme install twentytwentyfour --path=$WP_PATH --activate --allow-root
  wp theme activate twentytwentyfour --path=$WP_PATH --allow-root
  wp user create travis travis@test --role=author --path=$WP_PATH --user_pass=travis --allow-root
fi

/usr/sbin/php-fpm7.3 -F