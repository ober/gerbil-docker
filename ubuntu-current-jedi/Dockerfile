from ubuntu:latest

ARG GAMBIT_VERSION=master

ENV GAMBIT_HOME=/opt/gambit
ENV GAMBITDIR=/opt/gambit
ENV PATH=${GAMBIT_HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin
ENV CFLAGS="-D___DONT_USE_BUILTIN_SETJMP"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y
RUN apt install -y \
    autoconf \
    automake \
    build-essential \
    gfortran \
    git \
    libffi-dev \
    libglu1-mesa \
    libglu1-mesa-dev \
    libleveldb-dev \
    liblmdb-dev \
    libmysqlclient-dev \
    libsnappy1v5  \
    libsqlite3-dev \
    libssl-dev \
    libx11-dev \
    libyaml-dev \
    lsb-release \
    pkg-config \
    sudo \
    tmux \
    tzdata \
    wget \
    x11-xserver-utils \
    zlib1g-dev

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

RUN cd /opt/jedi && GAMBITDIR="/opt/gambit/v4.9.3" ./jaz make @develop
RUN mkdir -p /src

WORKDIR /src

CMD ["/opt/jedi/build/develop/jedi"]
