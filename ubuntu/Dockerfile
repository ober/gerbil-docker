from gerbil/gambit

MAINTAINER gerbil@cons.io

ARG squid

RUN cd /root/gerbil/src && ./build.sh stage0
RUN cd /root/gerbil/src && ./build.sh stage1
RUN sed -i -e 's/mysql #f/mysql #t/g' /root/gerbil/src/std/build-features.ss
RUN sed -i -e 's/leveldb #f/leveldb #t/g' /root/gerbil/src/std/build-features.ss
RUN sed -i -e 's/lmdb #f/lmdb #t/g' /root/gerbil/src/std/build-features.ss
RUN cd /root/gerbil/src && ./build.sh stdlib
RUN cd /root/gerbil/src && ./build.sh lang
RUN cd /root/gerbil/src && ./build.sh tools
RUN cd /root/gerbil/src && ./build.sh tags

CMD /root/gerbil/bin/gxi
