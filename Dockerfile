FROM ubuntu:trusty
MAINTAINER Helmi Ibrahim <helmi@tuxuri.com>

RUN hostname
RUN apt-get -y install aptitude
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y install wget
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y upgrade
RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN echo "___INSTALLED PACKAGES___BEFORE___"
RUN dpkg --get-selections
RUN aptitude install libgdal1h
RUN echo "___INSTALLED PACKAGES___AFTER___"
RUN dpkg --get-selections
RUN apt-get -y install postgresql-9.3 postgresql-contrib-9.3 postgresql-9.3-postgis-2.1 postgis postgresql-9.3-postgis-scripts
RUN echo "host    all             all             0.0.0.0/0               trust" >> /etc/postgresql/9.3/main/pg_hba.conf


RUN echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
RUN echo "port = 5432" >> /etc/postgresql/9.3/main/postgresql.conf
RUN echo "max_prepared_transactions = 10" >> /etc/postgresql/9.3/main/postgresql.conf
RUN service postgresql start;\
    /bin/su postgres -c "createuser -d -s -r -l root";\
    /bin/su postgres -c "psql postgres -c \"CREATE DATABASE root\"";\
    service postgresql stop

EXPOSE 5432

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]
