#!/usr/bin/env sh


# Play with docker support
Url="$1"
if [ -n "$SESSION_ID" ]; then
  Url="http://ip-${SESSION_ID}.direct.labs.play-with-docker.com"
  echo "$Url"
fi


# Host + Port parameters required for setting up the WordPress site
Host=${Url?Host required}
Port=${2:-80}


# Wait until WordPress container became ready
# See also https://github.com/wp-cli/wp-cli/issues/4106 .
until sleep 2s ; docker-compose exec wordpress \
  sudo -u www-data \
    wp db check > /dev/null
do
  echo "Waiting for WordPress container becoming ready..."
done
echo "WordPress container ready."

# Finish installation
docker-compose exec wordpress \
  sudo -u www-data \
    wp core install \
      --skip-email \
      --path=/var/www/html \
      --skip-email \
      --url=$Host:$Port \
      --title="Example site" \
      --admin_user=admin \
      --admin_password="test" \
      --admin_email=info@example.com

