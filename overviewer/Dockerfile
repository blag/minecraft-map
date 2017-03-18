FROM ubuntu:16.04
MAINTAINER blag

RUN echo "deb http://overviewer.org/debian ./" > /etc/apt/sources.list
RUN wget -O - http://overviewer.org/debian/overviewer.gpg.asc | apt-key add -

RUN apt update
RUN apt install -y --force-yes minecraft-overviewer

RUN mkdir -p /home/overviewer
RUN chown -R 1:1 /home/overviewer
ENV HOME=/home/overviewer
USER 1:1
ENTRYPOINT ["/bin/bash", "-c", "overviewer.py --config=/minecraft/overviewer.cfg; overviewer.py --config=/minecraft/overviewer.cfg --genpoi"]

# ADD crontab /etc/cron.d/minecraft-overviewer

# RUN chmod 664 /etc/cron.d/minecraft-overviewer

# RUN touch /var/log/cron.log

# CMD cron && tail -f /var/log/cron.log

# RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
#     echo "deb http://overviewer.org/debian ./" >> /etc/apt/sources.list && \
#     apt-get update

# RUN apt-get install -y --force-yes minecraft-overviewer

# ADD https://s3.amazonaws.com/Minecraft.Download/versions/1.11.2/1.11.2.jar /home/daemon/.minecraft/versions/1.11.2/
# RUN chown -R 1:1 /home/daemon
# ENV HOME=/home/daemon
# USER 1:1
# ENTRYPOINT ["overviewer.py"]
