#!/bin/bash

# This allows us to change the nginx configuration by simply changing the
# environment variables in docker-compose.yml and rebuilding the nginx image
envsubst '${DOMAIN_NAME} ${OTHER_HOSTNAMES} ${PORT_HTTP} ${PORT_HTTPS}' \
    < /etc/nginx/conf.d/default.conf.template \
    > /etc/nginx/conf.d/default.conf

# Skip all of the reconfiguration if it already exists
if [ ! -d "/etc/letsencrypt/live/${DOMAIN_NAME}" -o \
     ! -d "/etc/letsencrypt/live/${DOMAIN_NAME}/fullchain.pem" -o \
     ! -d "/etc/letsencrypt/live/${DOMAIN_NAME}/privkey.pem" ]; then

    echo "Firing up nginx in the background"

    nginx

    # Wait until the letsencrypt container has done its thing.
    # We see the changes here because there's a docker volume mapped.
    if [ ! -d "/etc/letsencrypt/live/${DOMAIN_NAME}" ]; then
        echo -n "Waiting for SSL directory (/etc/letsencrypt/live/${DOMAIN_NAME}) to exist..."
        while [ ! -d "/etc/letsencrypt/live/${DOMAIN_NAME}" ]; do
            sleep 2
        done
        echo "done."
    fi

    if [ ! -f "/etc/letsencrypt/live/${DOMAIN_NAME}/fullchain.pem" ]; then
        echo -n "Waiting for signing chain (fullchain.pem) to be set up..."
        while [ ! -f "/etc/letsencrypt/live/${DOMAIN_NAME}/fullchain.pem" ]; do
            sleep 2
        done
        echo "done."
    fi

    if [ ! -f "/etc/letsencrypt/live/${DOMAIN_NAME}/privkey.pem" ]; then
        echo -n "Waiting for private key (privkey.pem) to be set up..."
        while [ ! -f "/etc/letsencrypt/live/${DOMAIN_NAME}/privkey.pem" ]; do
            sleep 2
        done
        echo "done."
    fi

    echo "All SSL configuration complete!"

    echo -n "Restarting nginx..."
    kill $(ps aux | grep '[n]ginx' | awk '{print $2}')
    echo "done."

else
    echo "All configuration files found!"
    echo
    echo "Starting nginx"
    echo
fi

nginx -g 'daemon off;'
