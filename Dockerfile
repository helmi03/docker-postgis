FROM ubuntu:12.04
MAINTAINER Helmi <helmi@tuxuri.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y install wget
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install postgresql-9.3 postgresql-contrib-9.3 postgresql-9.3-postgis-2.1 postgis


RUN wget http://http.us.debian.org/debian/pool/main/b/boost1.54/libboost-system1.54.0_1.54.0-4_i386.deb
RUN  dpkg -i libboost-system1.54.0_1.54.0-4_i386.deb


RUN wget http://http.us.debian.org/debian/pool/main/b/boost1.54/libboost-thread1.54.0_1.54.0-4_i386.deb
RUN  dpkg -i libboost-thread1.54.0_1.54.0-4_i386.deb

RUN wget http://http.us.debian.org/debian/pool/main/m/mesa/libglapi-mesa_9.2.2-1_i386.deb 
RUN  dpkg -i libglapi-mesa_9.2.2-1_i386.deb 

RUN wget http://http.us.debian.org/debian/pool/main/libx/libx11/libx11-xcb1_1.6.2-1_i386.deb
RUN  dpkg -i libx11-xcb1_1.6.2-1_i386.deb

RUN wget http://http.us.debian.org/debian/pool/main/libx/libxcb/libxcb-dri2-0_1.10-2_i386.deb
RUN  dpkg -i libxcb-dri2-0_1.10-2_i386.deb

RUN wget http://http.us.debian.org/debian/pool/main/libx/libxcb/libxcb-glx0_1.10-2_i386.deb
RUN  dpkg -i libxcb-glx0_1.10-2_i386.deb

RUN wget http://http.us.debian.org/debian/pool/main/libx/libx11/libx11-6_1.6.2-1_i386.deb
RUN dpkg -i libx11-6_1.6.2-1_i386.deb

RUN wget  http://http.us.debian.org/debian/pool/main/libx/libxxf86vm/libxxf86vm1_1.1.3-1_i386.deb
RUN  dpkg -i libxxf86vm1_1.1.3-1_i386.deb


RUN wget http://http.us.debian.org/debian/pool/main/m/mesa/libgl1-mesa-glx_9.2.2-1_i386.deb
RUN  dpkg -i libgl1-mesa-glx_9.2.2-1_i386.deb

RUN wget http://http.us.debian.org/debian/pool/main/c/cgal/libcgal10_4.2-5+b2_i386.deb
RUN  dpkg -i libcgal10_4.2-5+b2_i386.deb



RUN wget http://http.us.debian.org/debian/pool/main/p/pgrouting/postgresql-9.3-pgrouting_2.0.0-2_i386.deb
RUN  dpkg -i postgresql-9.3-pgrouting_2.0.0-2_amd64.deb

RUN echo "host    all             all             0.0.0.0/0               trust >> /etc/postgresql/9.3/main/pg_hba.conf
RUN  service postgresql restart
RUN createdb yonder_trail -U postgres -0 postgres
RUN psql -U postgres -d yonder_trail -c 'create extension postgis;'
RUN psql -U postgres -d yonder_trail -c 'create extension pgrouting;'
RUN psql -U postgres -d yonder_trail -c 'create extension hstore;'
RUN psql -U postgres -d yonder_trail -c 'create extension "uuid-ossp";'


RUN echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/9.3/main/pg_hba.conf
RUN service postgresql start && /bin/su postgres -c "createuser -d -s -r -l docker" && /bin/su postgres -c "psql postgres -c \"ALTER USER docker WITH ENCRYPTED PASSWORD 'docker'\"" && service postgresql stop
RUN echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
RUN echo "port = 5432" >> /etc/postgresql/9.3/main/postgresql.conf

EXPOSE 5432

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]
