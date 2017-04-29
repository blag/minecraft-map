FROM jfloff/alpine-python:2.7
MAINTAINER blag

RUN echo \
 && echo "http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main" > /etc/apk/repositories \
 && echo "http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/community" >> /etc/apk/repositories

RUN apk add --update ca-certificates gettext openssl py-imaging py-numpy tar wget && rm -rf /var/cache/apk/*

RUN mkdir /src

# Download the source
RUN wget -q https://github.com/overviewer/Minecraft-Overviewer/tarball/master \
         -O /src/Minecraft-Overviewer.tar.gz

WORKDIR /src

RUN tar -xzvf Minecraft-Overviewer.tar.gz

RUN ln -s $(ls | grep -v 'Minecraft-Overviewer.tar.gz') Minecraft-Overviewer

# This isn't working yet
RUN (cd Minecraft-Overviewer; python2 setup.py build)
RUN (cd Minecraft-Overviewer; python2 setup.py install)

COPY run_overviewer /etc/periodic/15min/
RUN chmod +x /etc/periodic/15min/run_overviewer

CMD crond -l 2 -f
