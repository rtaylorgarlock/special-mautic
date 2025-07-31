# Build dependencies with Composer
FROM composer:2 AS vendor

# Set the working directory for the application.
WORKDIR /app

# Copy composer files from your repository.
# This allows us to leverage Docker's build cache. The vendor layer is only rebuilt if composer.json or composer.lock changes.
COPY composer.json composer.lock ./

# Install dependencies with production optimizations.
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Build the final Mautic image
FROM mautic/mautic:5-apache

# Set the working directory. This should be the Mautic root inside the container.
WORKDIR /var/www/html

# Remove the default Mautic code that comes with the base image.
RUN rm -rf .

# Copy the composer-built vendor directory from the 'vendor' stage.
COPY --from=vendor /app/vendor/ ./vendor/

# Copy all your application code from your Git repository into the container.
# This includes your docroot, config templates, etc.
COPY . .

# Copy the custom entrypoint script into the container and make it executable.
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint to our custom script.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# The default command for the official image is to start Apache.
CMD ["/docker-entrypoint.sh", "apache2-foreground"]
