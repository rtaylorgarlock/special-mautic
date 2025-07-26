# Start from the official Mautic latest image
FROM mautic/mautic:latest

# Switch to the root user temporarily to gain permissions for the install
USER root

# Run the composer command to add the amazon-mailer package
# We specify the working directory to ensure it runs in the right place
RUN composer require symfony/amazon-mailer --working-dir=/var/www/html
