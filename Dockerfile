FROM ubuntu:18.04
MAINTAINER marco@cruncher.ch

ENV PG_APP_HOME="/etc/docker-postgresql"\
    PG_VERSION=12 \
    PG_USER=postgres \
    PG_HOME=/var/lib/postgresql \
    PG_RUNDIR=/run/postgresql \
    PG_LOGDIR=/var/log/postgresql \
    PG_CERTDIR=/etc/postgresql/certs

ENV PG_BINDIR=/usr/lib/postgresql/${PG_VERSION}/bin \
    PG_DATADIR=${PG_HOME}/${PG_VERSION}/main

RUN echo "Building..." \
 && apt-get -y update && apt-get -y upgrade && apt-get -y install gnupg2 wget locales \
 && locale-gen en_US.UTF-8  \
 && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg ${PG_VERSION}" > /etc/apt/sources.list.d/pgdg.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y acl \
      postgresql-${PG_VERSION} postgresql-client-${PG_VERSION} postgresql-contrib-${PG_VERSION} \
      python3-pip python3.4 lzop pv daemontools build-essential python3-dev sudo git-core \
 && ln -sf ${PG_DATADIR}/postgresql.conf /etc/postgresql/${PG_VERSION}/main/postgresql.conf \
 && ln -sf ${PG_DATADIR}/pg_hba.conf /etc/postgresql/${PG_VERSION}/main/pg_hba.conf \
 && ln -sf ${PG_DATADIR}/pg_ident.conf /etc/postgresql/${PG_VERSION}/main/pg_ident.conf \
 && rm -rf ${PG_HOME} \
 && rm -rf /var/lib/apt/lists/* \
 && python3 -m pip install gevent==1.4.0 \
 && python3 -m pip install boto>=2.40.0 \
 && python3 -m pip install git+https://github.com/wal-e/wal-e.git@master

# 1.1.0 does not support python 3.6 properly
# See https://github.com/wal-e/wal-e/issues/322
# && python3 -m pip install wal-e[aws]==1.1.0


COPY runtime/ ${PG_APP_HOME}/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh


EXPOSE 5432/tcp
VOLUME ["${PG_HOME}", "${PG_RUNDIR}"]
WORKDIR ${PG_HOME}
ENTRYPOINT ["/sbin/entrypoint.sh"]
