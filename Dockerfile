FROM ubuntu:latest

LABEL maintainer="Phillip Dudley" version="0.2.0"

ENV DEBIAN_FRONTEND=noninteractive

# Обновляем и устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    cmake \
    pkg-config \
    libssl-dev \
    libgnutls28-dev \
    gnutls-bin \
    vim \
    certbot \
    python3-certbot \
    sudo \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Создаём пользователя IRC
RUN groupadd -r irc && useradd -m -g irc irc
USER irc
WORKDIR /home/irc

# Клонируем исходники и переключаемся на нужные версии
RUN git clone https://github.com/anope/anope.git && \
    git clone https://github.com/inspircd/inspircd.git && \
    cd anope && git checkout 2.0.3 && \
    cd ../inspircd && git checkout v2.0.21

# Сборка InspIRCd
RUN cd /home/irc/inspircd && \
    ./configure --enable-gnutls --enable-openssl --enable-epoll --enable-kqueue --prefix=/home/irc/ircd-build && \
    make && make install

# Пример конфигурации
RUN cp /home/irc/ircd-build/conf/examples/inspircd.conf.example /home/irc/ircd-build/conf/inspircd.conf

# Сборка Anope
RUN cd /home/irc/anope && \
    cmake -Bbuild -DINSTDIR=/home/irc/anope-services \
        -DRUNGROUP=irc \
        -DDEFUMASK=007 \
        -DCMAKE_BUILD_TYPE=RELEASE \
        -DUSE_PCH=OFF \
        . && \
    cmake --build build && \
    cmake --install build

# Скрипт начальной генерации сертификатов и запуска IRC-сервера
COPY entrypoint.sh /home/irc/entrypoint.sh
RUN chmod +x /home/irc/entrypoint.sh

ENTRYPOINT ["/home/irc/entrypoint.sh"]
