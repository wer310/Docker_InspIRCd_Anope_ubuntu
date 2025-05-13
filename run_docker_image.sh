#!/bin/bash
docker run -p 80:80 -p 443:443 -p 6667:6667 -p 6697:6697 -e DOMAIN=yourdomain.com --name my-ircd ircd
