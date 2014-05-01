FROM phusion/baseimage:0.9.9

RUN echo '#!/bin/sh' "\nexit 0" >  /usr/sbin/policy-rc.d

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

RUN echo "deb http://repo.percona.com/apt precise main" >> /etc/apt/sources.list
RUN echo "deb-src http://repo.percona.com/apt precise main" >> /etc/apt/sources.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes percona-server-server-5.6 percona-server-client-5.6 apache2 libapache2-mod-php5 php5-mysql php5-curl php5-json php5-mcrypt
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "[mysqld]\nbind-address=0.0.0.0" > /etc/mysql/my.cnf

RUN mkdir /etc/service/percona
ADD run.sh /etc/service/percona/run
RUN chmod 755 /etc/service/percona/run

ADD virtualhost /etc/apache2/sites-enabled/default
RUN rm -f /etc/apache2/sites-enabled/000-default
RUN a2enmod rewrite

RUN mkdir -p /etc/my_init.d
ADD start_apache.sh /etc/my_init.d/start_apache.sh

VOLUME ["/var/www", "/var/lib/mysql"]
EXPOSE 80
CMD ["/sbin/my_init"]
