FROM amazonlinux:latest
ARG PG_VERSION=12.2

RUN yum -y install vim gcc make curl tar gzip openssl-devel python2-devel python3-devel python-setuptools

WORKDIR /tmp
	
RUN curl -L -O "https://ftp.postgresql.org/pub/source/v${PG_VERSION}/postgresql-${PG_VERSION}.tar.gz" \
	&& tar -xzf postgresql-${PG_VERSION}.tar.gz \
	&& cd "postgresql-${PG_VERSION}" \
	&& ./configure  --without-readline --without-zlib --with-openssl \
	&& make \
	&& make install \
	&& cd ..
		
RUN curl -L -O 'http://initd.org/psycopg/tarballs/PSYCOPG-2-8/psycopg2-2.8.tar.gz' \
	&& tar -xzf psycopg2-2.8.tar.gz \
	&& cd psycopg2-2.8 \
	&& printf "[build_ext]\ndefine =\npg_config = /tmp/postgresql-${PG_VERSION}/src/bin/pg_config/pg_config\nmx_include_dir =\nhave_ssl = 1\nstatic_libpq = 1\nlibraries = ssl crypto\n\n[metadata]\nlicense_file = LICENSE\n\n[egg_info]\ntag_build =\ntag_date = 0\n" > setup.cfg \
	&& PYTHON_VERSION=2 make \
	&& PYTHON_VERSION=3 make \
	&& tar -zcvf psycopg2.tar.gz ./build/lib.2 \
	&& tar -zcvf psycopg3.tar.gz ./build/lib.3
