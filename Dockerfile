FROM hsmtkk/openssl:1.1.1g as builder

RUN yum -y update \
 && yum -y install gcc gcc-c++ libcurl-devel make zlib-devel

WORKDIR /usr/local/src

RUN curl -L -O https://www.clamav.net/downloads/production/clamav-0.102.2.tar.gz \
 && tar fxz clamav-0.102.2.tar.gz \
 && cd clamav-0.102.2 \
 && ./configure --prefix=/usr/local \
 && make \
 && make install

FROM hsmtkk/openssl:1.1.1g

COPY --from=builder /usr/local /usr/local

EXPOSE 1344
