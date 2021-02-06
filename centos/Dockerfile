from jaimef/base:centos

MAINTAINER gerbil@cons.io

ENV GAMBIT_VERSION v4.9.3
ENV GERBIL_VERSION v0.16

RUN git config --global url.https://github.com/.insteadOf git://github.com/
RUN cd /root && git clone https://github.com/gambit/gambit && cd /root/gambit && git fetch -a && git checkout ${GAMBIT_VERSION}

ENV LDFLAGS  "-L/usr/lib64/openssl11/"
RUN cd /root/gambit && ./configure --prefix=/usr/local/gambit --enable-single-host --enable-openssl --enable-default-runtime-options=f8,-8,t8 --enable-poll

RUN cd /root/gambit && make -j4
RUN cd /root/gambit && make install

ENV PATH "/usr/local/gambit/bin:$PATH"

RUN cd /root && git clone https://github.com/vyzo/gerbil && cd /root/gerbil && git checkout ${GERBIL_VERSION}

RUN bash

RUN cd /root/gerbil/src && ls && ./configure --prefix=/usr/local/gerbil --enable-leveldb --enable-libxml --enable-libyaml --enable-lmdb

ENV GERBIL_BUILD_CORES 4
RUN cd /root/gerbil/src && ./build.sh
RUN cd /root/gerbil/src && ./install


ENV GERBIL_HOME "/root/gerbil"
ENV PATH "/root/gerbil/bin:$PATH"

CMD ["gxi"]
