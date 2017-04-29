FROM nginx:alpine

RUN apk add --update bash

# ADD dhparams.pem /etc/ssl/private/
COPY conf.d/default.conf.template /etc/nginx/conf.d/

COPY start_nginx.sh /
RUN chmod +x /start_nginx.sh

CMD /start_nginx.sh
