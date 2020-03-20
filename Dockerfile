FROM php:7.2.24-fpm-stretch


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update -y
RUN apt-get install -y libaio-dev supervisor nano openssl unixodbc zip unzip git wget libfreetype6-dev libjpeg62-turbo-dev libpng-dev libldb-dev libldap2-dev unixodbc-dev


RUN docker-php-ext-install zip
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install bcmath
RUN pecl install sqlsrv pdo_sqlsrv
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv pcntl

RUN cd /tmp && git clone https://github.com/git-ftp/git-ftp.git && cd git-ftp \
    && tag="$(git tag | grep '^[0-9]*\.[0-9]*\.[0-9]*$' | tail -1)" \
    && git checkout "$tag" \
    && mv git-ftp /usr/local/bin && chmod +x /usr/local/bin

RUN docker-php-ext-install sockets

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN npm i -g yarn

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* /var/tmp/*