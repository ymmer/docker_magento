FROM ubuntu

RUN apt-get -y update && apt-get -y install \
  curl \
  wget \
  htop \
  vim \
  openssh-server \
  supervisor \
  apache2 \
  libapache2-mod-fcgid \
  apache2-mpm-worker \
  php5 \
  php5-cgi \
  mcrypt \
  php5-mcrypt \
  php5-curl \
  php5-gd \
  php5-mysql \
  php5-xcache \
  unzip \
  pwgen && \
  groupadd magento && \
  useradd -g magento -d /dev/null -s /etc magento


# fetch magento from internal server, instead of wget https://github.com/OpenMage/magento-mirror/archive/1.9.2.4.zip
# provide current adminer
RUN cd /var/www/html && \
  wget http://149.201.48.80/gq/magento.tar.gz && \
  tar -xf magento.tar.gz && \
  rm magento.tar.gz && \
  mv src magento && \
  cd /var/www/html/magento && \
  wget http://149.201.48.80/gq/adminer.bak && \
  mv adminer.bak adminer.php && \
  chown -R www-data:magento /var/www/html/magento && \
  chmod -R g+w /var/www/html/magento


# TODO: tar file
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD magento*.conf /etc/apache2/sites-available/
ADD .htaccess /var/www/html/magento/.htaccess
ADD php-fcgid-wrapper /usr/local/bin/php-fcgid-wrapper
ADD sshd.append /tmp/sshd.append
ADD run.sh /run.sh


# httpd / sshd
RUN a2dissite 000-default && \
  a2ensite magento && \
  a2enmod fcgid rewrite ssl && \
  php5enmod mcrypt && \
  chmod +x /usr/local/bin/php-fcgid-wrapper && \
  cat /tmp/sshd.append >> /etc/ssh/sshd_config && \
  chmod +x /run.sh && \
  service ssh start

EXPOSE 22 80

VOLUME ["/var/www/html/", "/var/log/"]

# todo
#USER magento

CMD ["/run.sh"]
