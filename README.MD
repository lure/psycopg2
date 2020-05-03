### psycopg2 for AWS

This repository contains psycopg2 2.8 binaries prebuilt for AWS AMI2 with Postgresql 11.2 WITH SSL support. Lambda IAM authorization does not work without it.
Binaries should support AMI 1 and nearly any postgresq version prior to 11. AWS Lambdas do not provide PostgreSQL client libraries on it's own, and psycopg seems to be the best at this moment.

To use it simply download the package, pick python version that you want to use and either pack it with your lambda or provide as a layer (see link at the end of the article). Note, that you have to rename the directory to `psycopg2`. Otherwise the lib will not be found.


### To build manually
Install docker, pull container, log into it

```
docker pull amazonlinux
docker run -it amazonlinux:latest /bin/bash

```

When inside

```
cd home
yum groupinstall "Development Tools"
yum install vim
yum install openssl-devel
yum install python2-devel 
yum install python3-devel

# latest sources and version may be found at https://ftp.postgresql.org/pub/latest/
curl -O 'https://ftp.postgresql.org/pub/source/v11.2/postgresql-11.2.tar.gz' && tar -xzf postgresql-11.2.tar.gz
curl -O 'http://initd.org/psycopg/tarballs/PSYCOPG-2-8/psycopg2-2.8.tar.gz' && tar -xzf psycopg2-2.8.tar.gz

cd postgresql-11.2
./configure  --without-readline --without-zlib --with-openssl && make && make install
cd psycopg2-2.8 
vim ./setup.cfg 
```

Now being editing `setup.cfg`, set following lines

```
pg_config = /home/postgresql-11.2/src/bin/pg_config/pg_config
have_ssl = 1
static_libpq = 1
libraries = ssl crypto
```

Save & exit, continue with

```
configure 
make 
```

This will build the library for default python which is usually 2. If you want a different one use `PYTHON_VERSION=3 make` 
instead.  To get compiled from container, first archive the build and next retrieve it to your filesystem

```
tar -zcvf ./build/lib... %filename%
docker cp %container%:/%filename %path%
``` 

It is up to you to figure out how to make lmbda layer or pack the lib with your code. 

Usefull sources: 
1. How to prepare for compilation on AMI2 https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/compile-software.html
2. Obsolete package list, but somewhat useful: https://aws.amazon.com/amazon-linux-ami/2018-03-packages/
3. psycopg docs on compilation http://initd.org/psycopg/docs/install.html#install-from-source
4. AWS lambda layers doc: https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html

