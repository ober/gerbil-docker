FROM alpine:latest

ARG GAMBIT_VERSION=master
ARG GERBIL_VERSION=master

ENV GAMBIT_HOME=/opt/gerbil
ENV GERBIL_HOME=/opt/gerbil
ENV GERBIL_PATH=/src/.gerbil
ENV PATH=${GAMBIT_HOME}/bin:${GERBIL_HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin
ENV GERBIL_BUILD_CORES=1

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
    && ./configure CC='gcc -D___SUPPORT_LOWLEVEL_EXEC' \
    --enable-default-runtime-options=f8,-8,t8 \
    --enable-poll \
    --enable-openssl \
    --enable-targets=js,ruby,python,java,php,go,x86-64 \
    --enable-default-compile-options="(compactness 9)" \
    --enable-multiple-versions \
    --enable-single-host \
    --prefix=${GAMBIT_HOME} \
    --enable-smp

#    --enable-multiple-threaded-vms \ # segfaults

RUN cd /opt/gambit-src && make -j8
RUN cd /opt/gambit-src && make bootstrap
RUN cd /opt/gambit-src && make bootclean
RUN cd /opt/gambit-src && make -j8
RUN cd /opt/gambit-src && make -j8 modules
RUN cd /opt/gambit-src && make install

# install gerbil
RUN cd /opt && git clone https://github.com/vyzo/gerbil gerbil-src
ENV PATH=/opt/gerbil/v4.9.3/bin:$PATH
RUN cd /opt/gerbil-src/src \
    && ./configure \
    --prefix=${GERBIL_HOME} \
    --enable-leveldb \
    --enable-libxml \
    --enable-libyaml \
    --enable-lmdb
RUN cd /opt/gerbil-src/src && ./build.sh
RUN cd /opt/gerbil-src/src && ./install

RUN mkdir -p /src

WORKDIR /src

CMD ["gxi"]
