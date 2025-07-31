#!/bin/sh
# Exit immediately if a command exits with a non-zero status.
set -e

# Define the Mautic directory.
# CHANGE '/var/www/html/docroot' if your web root is different.
MAUTIC_DIR="/var/www/html/docroot"

echo "Running Mautic entrypoint script..."

# Set correct permissions. The 'var' and 'media' directories,
# and the local config file, need to be writable by the web server (www-data).
echo "Setting permissions..."
chown -R www-data:www-data $MAUTIC_DIR/var
chown -R www-data:www-data $MAUTIC_DIR/media
chown www-data:www-data $MAUTIC_DIR/config/local.php

# Run database migrations to ensure the schema is up to date.
# This is crucial for updates and initial installation.
echo "Applying database migrations..."
php $MAUTIC_DIR/bin/console doctrine:migrations:migrate --no-interaction

# Clear the Mautic cache to apply any changes.
echo "Clearing Mautic cache..."
php $MAUTIC_DIR/bin/console cache:clear

echo "Entrypoint script finished. Starting Apache..."

# Execute the original command (CMD) passed to the container.
# In our case, this will be ["/docker-entrypoint.sh", "apache2-foreground"].
exec "$@"