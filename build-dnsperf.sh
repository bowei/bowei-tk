#!/bin/bash

set -e

dnsperf_url="ftp://ftp.nominum.com/pub/nominum/dnsperf/2.1.0.0/dnsperf-src-2.1.0.0-1.tar.gz"
image="bowei-tk-alpine-dnsperf-build"

rm -rf build/
mkdir -p build/
wget "${dnsperf_url}" -O build/dnsperf.tgz
pushd build/ >/dev/null
tar -xzf dnsperf.tgz
ln -s dnsperf-src-* src

cat <<END > Dockerfile
FROM alpine

RUN apk update
RUN apk add \
  bind \
  bind-dev \
  bind-libs \
  gcc \
  libcap \
  libcap-dev \
  libpcap \
  libpcap-dev \
  make \
  musl-dev \
  openssl-dev

END

docker build -t "${image}" .
docker run -it -v `pwd`/src:/src "${image}" sh -c "cd /src && ./configure && make"
container=$(docker ps -l -q)

popd >/dev/null

for filename in dnsperf resperf; do
  cp build/src/${filename} .
done
