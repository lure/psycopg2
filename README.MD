### psycopg2 for AWS

This repository contains psycopg2 2.8 binaries prebuilt for AWS AMI2 with Postgresql 11.2 WITH SSL support. Lambda IAM authorization does not work without it.
Binaries should support AMI 1 and nearly any postgresq version prior to 11. AWS Lambdas do not provide PostgreSQL client libraries on it's own, and psycopg seems to be the best at this moment.

To use it simply download the package, pick python version that you want to use and either pack it with your lambda or provide as a layer (see link at the end of the article). Note, that you have to rename the directory to `psycopg2`. Otherwise the lib will not be found.


### To build manually
Install docker and then

```bash
# default pg and python version
./build.sh 
# two params are provided: PG -- postgresql version and PY - major python version. Example: 
PG=12.2 PY=3 ./build.sh 
```

Find the package named `/tmp/psycopg${PY}.tar.gz` in current dir. The archive structure is all set to be used as a layer.
You may log in into container using 

```
docker run -v `pwd`:/opt --rm -ti lure/psycopg28 bash
```  

to compile something else while the image still exists. 

Don't forget to delete image if no longer needed, it's around 1gb in size.

Usefull sources: 
1. How to prepare for compilation on AMI2 https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/compile-software.html
2. Obsolete package list, but somewhat useful: https://aws.amazon.com/amazon-linux-ami/2018-03-packages/
3. psycopg docs on compilation http://initd.org/psycopg/docs/install.html#install-from-source
4. AWS lambda layers doc: https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html

