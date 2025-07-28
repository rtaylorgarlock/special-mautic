# Force rebuild
FROM mautic/mautic:5-apache

USER root

RUN composer require symfony/amazon-mailer --working-dir=/var/www/html

# beginning to wonder why i'm still trying
