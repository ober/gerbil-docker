FROM alpine:latest

ARG GAMBIT_VERSION=master
ARG GERBIL_VERSION=master

ENV GAMBIT_HOME=/opt/gerbil
ENV GERBIL_HOME=/opt/gerbil
ENV GERBIL_PATH=/src/.gerbil
ENV PATH=${GAMBIT_HOME}/bin:${GERBIL_HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin
ENV GERBIL_BUILD_CORES=4

RUN mkdir -p /src /opt

RUN apk update && apk add \
    autoconf \
    automake \
    curl \
    gcc \
    git \
    leveldb \
    leveldb-dev \
    libgcc \
    libtool \
    libxml2-dev \
    linux-headers \
    lmdb-dev \
    make \
    mariadb-dev \
    musl \
    musl-dev \
    nodejs \
    openssl-dev \
    openssl-libs-static \
    sqlite-dev \
    yaml-dev \
    yaml-static \
    zlib-static

RUN git config --global url.https://github.com/.insteadOf git://github.com/

# install gambit
RUN cd /opt && git clone https://github.com/gambit/gambit gambit-src
RUN cd /opt/gambit-src && git fetch -a

RUN cd /opt/gambit-src \
    && sed -i -e 's#SSL_VERIFY_PEER#SSL_VERIFY_NONE#g' lib/os_io.c \
    && ./configure \
    --enable-openssl \
    --enable-default-runtime-options=f8,-8,t8 \
    --enable-poll \
    --enable-multiple-versions \
    --prefix=${GAMBIT_HOME} \
    --enable-rtlib-debug-environments \
    --enable-rtlib-debug-location \
    --enable-single-host \
    --enable-track-scheme \
    CFLAGS=-D___DONT_USE_BUILTIN_SETJMP

RUN cd /opt/gambit-src && make -j4
RUN cd /opt/gambit-src && make bootstrap
RUN cd /opt/gambit-src && make bootclean
RUN cd /opt/gambit-src && make -j4
RUN cd /opt/gambit-src && make -j4 modules
RUN cd /opt/gambit-src && make install

RUN mkdir -p /src

WORKDIR /src

CMD ["gsi"]