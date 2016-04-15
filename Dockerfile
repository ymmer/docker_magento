FROM ubuntu

RUN apt-get -y update && apt-get -y install \
  curl \
  wget \
  supervisor \
  apache2 \
  libapache2-mod-php5 \
  php5 \
  mcrypt \
  php5-mcrypt \
  php5-curl \
  php5-gd \
  php5-mysql \
  unzip \
  pwgen && \
  php5enmod mcrypt


ADD start-apache2.sh /start-apache2.sh
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD startupscript.sh /var/www/startupscript.sh
RUN chmod 755 /*.sh


# todo: variable for magento version
# zip? better provide the tar.gz file in git?
RUN cd /var/www/html && \
  wget https://github.com/OpenMage/magento-mirror/archive/1.9.2.4.zip && \
  unzip 1.9.2.4.zip && \
  rm 1.9.2.4.zip && \
  mv magento-mirror-1.9.2.4 magento && \
  chown -R www-data:www-data magento 

# provide current adminer
RUN cd /var/www/html/magento && \
  wget https://www.adminer.org/static/download/4.2.4/adminer-4.2.4-mysql-de.php && \
  mv adminer-4.2.4-mysql-de.php adminer.php && \
  chown www-data:www-data adminer.php


# todo: volumes
EXPOSE 80 

USER www-data
CMD ["/var/www/startupscript.sh"]
