FROM gitpod/workspace-full

RUN sudo apt-get update -q \
    && sudo apt-get install -y php-dev

RUN curl -L http://xdebug.org/files/xdebug-2.9.6.tgz -o /tmp/xdebug-2.9.6.tgz \
    && cd /tmp \
    && tar xf xdebug-2.9.6.tgz \
    && cd xdebug-2.9.6 \
    && phpize \
    && ./configure \
    && make
