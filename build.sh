#!/bin/bash
set -e
PG="${PG:-12.2}"
PY=${PY:-3}
docker build --build-arg PG_VERSION=$PG --build-arg PY_VERSION=$PY -t lure/psycopg28 . 
docker run -v `pwd`:/opt --rm -ti lure/psycopg28 bash -c "cp /tmp/psycopg${PY}.tar.gz /opt"
