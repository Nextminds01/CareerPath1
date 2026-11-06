FROM php:8.2-apache

# Install MySQL extensions for PDO and MySQLi
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy all application files into Apache document root
COPY . /var/www/html/

# Set appropriate file ownership and permissions for Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose Render default container port
EXPOSE 10000

# Dynamically bind Apache to Render's $PORT (defaults to 10000) and start Apache
CMD sh -c "sed -i \"s/Listen [0-9]*/Listen \${PORT:-10000}/\" /etc/apache2/ports.conf && sed -i \"s/:[0-9]*>/:\\${PORT:-10000}>/\" /etc/apache2/sites-available/000-default.conf && exec apache2-foreground"
