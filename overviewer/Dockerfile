FROM ubuntu:16.04
MAINTAINER blag

RUN echo "deb http://us.archive.ubuntu.com/ubuntu xenial main universe multiverse restricted" >> /etc/apt/sources.list.d/us.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu xenial main universe multiverse restricted" >> /etc/apt/sources.list.d/us.list

RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates main universe multiverse restricted" >> /etc/apt/sources.list.d/updates.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-updates main universe multiverse restricted" >> /etc/apt/sources.list.d/updates.list

RUN echo "deb http://security.archive.ubuntu.com/ubuntu/ xenial-security main universe multiverse restricted" >> /etc/apt/sources.list.d/security.list
RUN echo "deb-src http://security.archive.ubuntu.com/ubuntu/ xenial-security main universe multiverse restricted" >> /etc/apt/sources.list.d/security.list

RUN apt update
RUN apt upgrade -y
RUN apt install -y apt-transport-https apt-utils cron gettext-base lsb-release wget

# Install Overviewer
RUN echo "deb https://overviewer.org/debian ./" > /etc/apt/sources.list.d/overviewer.list
RUN wget -q -O - https://overviewer.org/debian/overviewer.gpg.asc | apt-key add -

RUN apt update
RUN apt install -y minecraft-overviewer

# Add the script to run Overviewer
COPY run_overviewer /
RUN chmod +x /run_overviewer

# Configure the cron job to run the overviewer script
RUN echo "15,30,45,60 * * * * root /run_overviewer >> /var/log/cron.log 2>&1" >> /etc/cron.d/run-overviewer
RUN chmod +x /etc/cron.d/run-overviewer

RUN touch /var/log/cron.log

CMD cron && tail -f /var/log/cron.log
