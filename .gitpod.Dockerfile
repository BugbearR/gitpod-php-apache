FROM gitpod/workspace-mysql

USER root

#default
ENV APACHE_DOCROOT_IN_REPO=public

ENV X_TMP=/tmp/x_tmp
ENV XDEBUG_VERSION=2.9.6
ENV X_PHP_EXT_DIR=/usr/lib/php/20190902
ENV X_PHP_CLI_CONF_D=/etc/php/7.4/cli/conf.d
ENV X_PHP_APACHE2_CONF_D=/etc/php/7.4/apache2/conf.d
ENV X_CLI_DEBUG_PORT=9001
ENV X_APACHE2_DEBUG_PORT=9000

#    && export X_PHP_INI_CONFD=$(php --ini | grep 'Scan for additional .ini files in: ' | sed -e 's/^[^:]*: //') \
#    && export X_PHP_LIB=$(php -r "echo ini_get('extension_dir');") \

WORKDIR ${X_TMP}

COPY common/render_template.sh ${X_TMP}
COPY xdebug/99-xdebug.ini.tmpl ${X_TMP}

#    && sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-dev \
 
RUN sudo apt-get update -q \
    && sudo apt-get install -y php-dev \
    && cd ${X_TMP} \
    && curl -L http://xdebug.org/files/xdebug-${XDEBUG_VERSION}.tgz -o xdebug-${XDEBUG_VERSION}.tgz \
    && tar xf xdebug-${XDEBUG_VERSION}.tgz \
    && cd xdebug-${XDEBUG_VERSION} \
    && phpize \
    && ./configure --enable-xdebug \
    && make \
    && make install \
    && cd ${X_TMP} \
    && X_PORT=${X_CLI_DEBUG_PORT} sh ./render_template.sh 99-xdebug.ini.tmpl >${X_PHP_CLI_CONF_D}/99-xdebug.ini \
    && X_PORT=${X_APACHE2_DEBUG_PORT} sh ./render_template.sh 99-xdebug.ini.tmpl >${X_PHP_APACHE2_CONF_D}/99-xdebug.ini \
    && addgroup gitpod www-data \
    && apt-get clean \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/* ${X_TMP}

COPY php/php.ini /etc/php/7.4/cli/
COPY apache2/php.ini /etc/php/7.4/apache2/
COPY apache2/apache2.conf /etc/apache2/
