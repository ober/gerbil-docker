from jaimef/base:centos

MAINTAINER gerbil@cons.io

ENV GAMBIT_VERSION v4.9.3
ENV GERBIL_VERSION v0.15.1

RUN git config --global url.https://github.com/.insteadOf git://github.com/
RUN cd /root && git clone https://github.com/gambit/gambit && cd /root/gambit && git fetch -a && git checkout ${GAMBIT_VERSION}

RUN cd /root/gambit && ./configure --prefix=/usr/local/gambit --enable-single-host --enable-openssl --enable-default-runtime-options=f8,-8,t8 --enable-poll
RUN cd /root/gambit && make -j4
RUN cd /root/gambit && make install

ENV PATH "/usr/local/gambit/bin:$PATH"

RUN cd /root && git clone https://github.com/vyzo/gerbil && cd /root/gerbil && git checkout ${GERBIL_VERSION}

#RUN sed -i -e 's/mysql #f/mysql #t/g' /root/gerbil/src/std/build-features.ss
RUN sed -i -e 's/yaml #f/yaml #t/g' /root/gerbil/src/std/build-features.ss
RUN sed -i -e 's/leveldb #f/leveldb #t/g' /root/gerbil/src/std/build-features.ss
#RUN sed -i -e 's/lmdb #f/lmdb #t/g' /root/gerbil/src/std/build-features.ss
RUN cd /root/gerbil/src && ./build.sh stage0
RUN cd /root/gerbil/src && ./build.sh stage1
RUN cd /root/gerbil/src && ./build.sh stdlib
RUN cd /root/gerbil/src && ./build.sh lang
RUN cd /root/gerbil/src && ./build.sh r7rs_large
RUN cd /root/gerbil/src && ./build.sh tools
RUN cd /root/gerbil/src && ./build.sh tags

ENV GERBIL_HOME "/root/gerbil"
ENV PATH "/root/gerbil/bin:$PATH"

CMD ["gxi"]
