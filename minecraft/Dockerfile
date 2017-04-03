FROM alpine:3.5
MAINTAINER blag

RUN apk add --update bash wget

COPY download_minecraft_files /etc/periodic/15min/
RUN chmod +x etc/periodic/15min/download_minecraft_files

RUN mkdir -p /mnt/minecraft

CMD crond -l 2 -f
