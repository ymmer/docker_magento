FROM ubuntu

# RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && apt-get -y install lamp-server
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && apt-get -y install \
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
  mysql-server \
  unzip \
  pwgen

RUN DEBIAN_FRONTEND=noninteractive php5enmod mcrypt

ADD adminer.php /var/www/html/magento/
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh
RUN rm -rf /var/lib/mysql/*


# todo: variable for magento version
# zip? better provide the tar.gz file in git?
RUN cd /var/www/html && \
  wget https://github.com/OpenMage/magento-mirror/archive/1.9.2.4.zip && \
  unzip magento-1.9.2.4.zip && \
  rm magento-1.9.2.4.zip && \
  mv magento-1.9.2.4 magento && \
  chown -R www-data:www-data magento 

ADD startupscript.sh /var/www/startupscript.sh

RUN chmod 755 /var/www/*.sh

EXPOSE 80 3306

CMD ["/var/www/startupscript.sh"]
