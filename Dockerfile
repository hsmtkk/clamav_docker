FROM hsmtkk/openssl:1.1.1g as builder

RUN apt -y update \
 && apt -y install curl gcc g++ libcurl4-openssl-dev make zlib1g-dev

WORKDIR /usr/local/src

RUN curl -L -O https://www.clamav.net/downloads/production/clamav-0.102.2.tar.gz \
 && tar fxz clamav-0.102.2.tar.gz \
 && cd clamav-0.102.2 \
 && ./configure --prefix=/usr/local/clamav --with-openssl=/usr/local/openssl \
 && make \
 && make install

FROM hsmtkk/openssl:1.1.1g

COPY --from=builder /usr/local/clamav /usr/local/clamav

RUN touch /usr/local/clamav/etc/clamd.conf && env LD_LIBRARY_PATH=/usr/local/openssl/lib /usr/local/clamav/sbin/clamd --version
