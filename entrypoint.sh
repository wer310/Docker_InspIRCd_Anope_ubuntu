#!/bin/bash

# Убедиться, что есть домен
if [ -z "$DOMAIN" ]; then
  echo "Ошибка: переменная окружения DOMAIN не установлена."
  exit 1
fi

# Генерация сертификата
if [ ! -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
  echo "Запрашивается SSL-сертификат для $DOMAIN..."
  sudo certbot certonly --standalone -d "$DOMAIN" --agree-tos --non-interactive -m admin@$DOMAIN
fi

# Копирование сертификатов в IRC директорию
cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" /home/irc/ircd-build/conf/fullchain.pem
cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" /home/irc/ircd-build/conf/privkey.pem

# Запуск InspIRCd
echo "Запуск InspIRCd..."
/home/irc/ircd-build/inspircd start

# Запуск Anope
echo "Запуск Anope Services..."
/home/irc/anope-services/bin/services
