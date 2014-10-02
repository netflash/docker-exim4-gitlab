FROM debian:stable
MAINTAINER alex@romanov.ws
# Based on https://github.com/mildred/docker-mail/commit/f147cc27cdbf5327390facf055fbb0bcd30e1c8d

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales-all locales 

# === debug tools start ===
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y net-tools 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y netcat 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y procps 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y man 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y lsof 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y less 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y psmisc
# === debug tools stop ===
# === exim4 start ===
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libswitch-perl libtasn1-3 mysql-common perl perl-modules 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libsasl2-modules libsqlite3-0 libssl1.0.0
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libp11-kit0 libpcre3
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y exim4
# === exim4 stop ===

RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX

VOLUME /mnt
VOLUME /var/log/exim
VOLUME /var/log/exim4
VOLUME /var/spool/exim4

WORKDIR /

COPY exim4.conf.tpl /etc/exim4/exim4.conf.tpl
COPY entry.sh       /entry.sh

EXPOSE 25
ENTRYPOINT ["/bin/bash", "/entry.sh"]
CMD ["init"]
