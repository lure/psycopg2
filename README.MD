### psycopg2 for AWS

This repository contains psycopg2 2.8 binaries prebuilt for AWS AMI2 with Postgresql 11.2 WITH SSL support. Lambda IAM authorization does not work without it.
Binaries should support AMI 1 and nearly any postgresq version prior to 11. AWS Lambdas do not provide PostgreSQL client libraries on it's own, and psycopg seems to be the best at this moment.

To use it simply download the package, pick python version that you want to use and either pack it with your lambda or provide as a layer (see link at the end of the article). Note, that you have to rename the directory to `psycopg2`. Otherwise the lib will not be found.


### To build manually
Install docker and then

```bash
#!/bin/bash
set -e
docker build -t lure/psycopg28
id=$(docker create lure/psycopg28)
docker cp $id:/tmp/psycopg2-2.8/psycopg2.tar.gz ./
docker cp $id:/tmp/psycopg2-2.8/psycopg3.tar.gz ./
docker rm -v $id
docker rmi lure/psycopg28

# OR
# docker run -v $PWD:/opt/mount --rm -ti lure/psycopg28 bash -c "cp /tmp/psycopg2-2.8/*.tar.gz /opt/mount/"
```
Lambda layer requires content of this files to be put into `python` folder inside the archive. 

Usefull sources: 
1. How to prepare for compilation on AMI2 https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/compile-software.html
2. Obsolete package list, but somewhat useful: https://aws.amazon.com/amazon-linux-ami/2018-03-packages/
3. psycopg docs on compilation http://initd.org/psycopg/docs/install.html#install-from-source
4. AWS lambda layers doc: https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html

