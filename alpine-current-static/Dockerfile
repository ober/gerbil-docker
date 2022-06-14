FROM alpine:latest

ARG GAMBIT_VERSION=v4.9.4
ARG GERBIL_VERSION=v0.17.0

ENV GAMBIT_HOME=/opt/gambit
ENV GERBIL_HOME=/opt/gerbil
ENV GERBIL_PATH=/src/.gerbil
ENV PATH=${GAMBIT_HOME}/bin:${GERBIL_HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin
ENV GERBIL_BUILD_CORES=8

RUN mkdir -p /src /opt

RUN apk update && apk add \
    autoconf \
    automake \
    bash \
    coreutils \
    cmake \
    curl \
    g++ \
    gcc \
    git \
    libgcc \
    libtool \
    leveldb-dev\
    lmdb-dev \
    libxml2-dev \
    linux-headers \
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

RUN cd /src && git clone --recurse-submodules https://github.com/google/leveldb.git
RUN cd /src/leveldb && mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .
RUN cd /src/leveldb && mv build/libleveldb.a /usr/lib

RUN cd /src && git clone https://github.com/LMDB/lmdb
RUN cd /src/lmdb/libraries/liblmdb && make
RUN cd /src/lmdb/libraries/liblmdb && mv liblmdb.a /usr/lib

RUN git config --global url.https://github.com/.insteadOf git://github.com/

# install gambit
RUN cd /opt && git clone https://github.com/gambit/gambit gambit-src
RUN cd /opt/gambit-src && git fetch -a

RUN cd /opt/gambit-src \
    && git fetch -a \
    && git checkout ${GAMBIT_VERSION} \
    && ./configure \
    --enable-default-runtime-options=f8,-8,t8 \
    --enable-poll \
    --enable-openssl \
    --enable-multiple-versions \
    --enable-single-host \
    --prefix=${GAMBIT_HOME}

#CC='gcc -D___SUPPORT_LOWLEVEL_EXEC' \
#    --enable-targets=js,ruby,python \
#    --enable-default-compile-options="(compactness 9)" \

RUN cd /opt/gambit-src && make -j${GERBIL_BUILD_CORES}
RUN cd /opt/gambit-src && make bootstrap
RUN cd /opt/gambit-src && make bootclean
RUN cd /opt/gambit-src && make -j${GERBIL_BUILD_CORES}
RUN cd /opt/gambit-src && make -j${GERBIL_BUILD_CORES} modules
RUN cd /opt/gambit-src && make install

#install gerbil
RUN cd /opt && git clone https://github.com/vyzo/gerbil gerbil-src
ENV PATH=/opt/gambit/current/bin:$PATH
RUN cd /opt/gerbil-src/src \
    && ./configure \
    --prefix=${GERBIL_HOME} \
    --enable-leveldb \
    --enable-libxml \
    --enable-libyaml \
    --enable-mysql \
    --enable-lmdb
RUN cd /opt/gerbil-src/src && ./build.sh
RUN cd /opt/gerbil-src/src && ./install

WORKDIR /src

CMD ["gxi"]
