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

ADD magento.conf /etc/apache2/sites-available/magento.conf

RUN chmod 755 /*.sh && chmod 755 /var/www/startupscript.sh && \
  a2dissite 000-default && a2ensite magento && \
  a2enmod rewrite


# fetch magento from internal server, instead of wget https://github.com/OpenMage/magento-mirror/archive/1.9.2.4.zip
RUN cd /var/www/html && \
  wget http://149.201.48.80/gq/magento.tar.gz && \
  tar -xf magento.tar.gz && \
  rm magento.tar.gz && \
  mv src magento && \
  chown -R www-data:www-data magento 

# provide current adminer
RUN cd /var/www/html/magento && \
  wget https://www.adminer.org/static/download/4.2.4/adminer-4.2.4-mysql-de.php && \
  mv adminer-4.2.4-mysql-de.php adminer.php && \
  chown www-data:www-data adminer.php


# todo: volumes
EXPOSE 80 8080

CMD ["/var/www/startupscript.sh"]
