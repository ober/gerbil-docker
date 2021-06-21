FROM alpine:latest

ARG GAMBIT_VERSION=master
ARG GERBIL_VERSION=master

ENV GAMBIT_HOME=/opt/gambit
ENV PATH=${GAMBIT_HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin

RUN mkdir -p /src /opt

RUN apk update && apk add \
    autoconf \
    automake \
    curl \
    gcc \
    git \
    leveldb \
    leveldb-dev \
    file \
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

RUN curl -L -k  -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN curl -L -k -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.33-r0/glibc-2.33-r0.apk && apk add glibc-2.33-r0.apk

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
    CFLAGS="-D___DONT_USE_BUILTIN_SETJMP"

RUN cd /opt/gambit-src && make -j4
RUN cd /opt/gambit-src && make bootstrap
RUN cd /opt/gambit-src && make bootclean
RUN cd /opt/gambit-src && make -j4
RUN cd /opt/gambit-src && make -j4 modules
RUN cd /opt/gambit-src && make install

RUN cd /opt && git clone https://github.com/jazzscheme/jedi
RUN cd /opt/jedi && git clone https://github.com/jazzscheme/jazz
RUN cd /opt/jedi/jazz && git checkout bongo

RUN cd /opt/jedi && GAMBITDIR="/opt/gerbil/current" ./jaz make kernel@develop
RUN mkdir -p /src

WORKDIR /src

CMD ["gsi"]
