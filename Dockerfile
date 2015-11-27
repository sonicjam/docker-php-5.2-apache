FROM centos:centos5

MAINTAINER Yu Inao <yu.inao@sonicjam.co.jp>

ENV PHP_VERSION 5.2.17

# Initial setup
RUN yum update -y
RUN yum groupinstall -y 'Development Tools'

# Apache installation
RUN yum install -y httpd httpd-devel

# PHP 5.2 dependency installation
RUN yum install -y \
  libaio-devel \
  libmcrypt-devel \
  libjpeg-devel \
  libpng-devel \
  libxml2-devel \
  libxslt-devel \
  curl-devel \
  freetype-devel \
  gmp-devel \
  mysql-devel \
  openssl-devel \
  postgresql-devel \
  sqlite-devel
WORKDIR /usr/local/src
COPY ./oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm /usr/local/src/
COPY ./oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm /usr/local/src/
RUN rpm -ivh ./oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
RUN rpm -ivh ./oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
ENV LD_LIBRARY_PATH /usr/lib/oracle/12.1/client64/lib:${LD_LIBRARY_PATH}
ENV PATH /usr/lib/oracle/11.2/client64/bin:${PATH}
RUN ln -s /usr/lib/oracle/11.2/client64 /usr/lib/oracle/11.2/client
RUN ln -s /usr/include/oracle/11.2/client64  /usr/include/oracle/11.2/client
RUN ldconfig

# PHP 5.2 installation
ADD http://museum.php.net/php5/php-${PHP_VERSION}.tar.bz2 /usr/local/src/
RUN tar xf ./php-${PHP_VERSION}.tar.bz2 -C ./
WORKDIR /usr/local/src/php-${PHP_VERSION}
RUN ./configure \
  --enable-gd-native-ttf \
  --enable-mbregex \
  --enable-mbstring \
  --enable-soap \
  --enable-zend-multibyte \
  --enable-zip \
  --with-apxs2 \
  --with-curl \
  --with-freetype-dir=/usr \
  --with-gd \
  --with-gettext \
  --with-gmp \
  --with-jpeg-dir=/usr \
  --with-mcrypt \
  --with-mysql-sock \
  --with-openssl \
  --with-pear \
  --with-pdo-mysql \
  --with-pdo-oci=instantclient,/usr,11.2 \
  --with-pdo-pgsql \
  --with-png-dir=/usr \
  --with-xsl \
  --with-zlib
RUN make && make test && make install

# Apache setup and launching
COPY ./httpd.conf /etc/httpd/conf/extra.conf
RUN echo 'Include /etc/httpd/conf/extra.conf' >> /etc/httpd/conf/httpd.conf
EXPOSE 80

VOLUME [ "/data", "/var/www/html" ]

CMD [ "/usr/sbin/httpd", "-D", "FOREGROUND" ]
