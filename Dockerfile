ARG distro
ARG squid

FROM ${distro}:latest as base
ARG squid
#ENV all_proxy=http://${squid}:3128
#ENV httpd_proxy=http://${squid}:3128
#ENV http_proxy=http://${squid}:3128
ARG GERBIL_VERSION=v0.17.0
ARG GAMBIT_VERSION=v4.9.4
ENV GERBIL_BUILD_CORES=8
ENV DEBIAN_FRONTEND=noninteractive
ARG distro
RUN mkdir -p /src /opt
RUN case ${distro} in \
    alpine) \
    apk update && apk add autoconf automake cmake curl g++ gcc git libgcc libtool leveldb-dev lmdb-dev libxml2-dev linux-headers make mariadb-dev musl musl-dev nodejs openssl-dev openssl-libs-static ruby sqlite-dev yaml-dev yaml-static zlib-static && \
    cd /src && git clone --recurse-submodules https://github.com/google/leveldb.git && cd /src/leveldb && mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build . &&  mv libleveldb.a /usr/lib && \
    cd /src && git clone https://github.com/LMDB/lmdb && cd /src/lmdb/libraries/liblmdb && make && cd /src/lmdb/libraries/liblmdb && mv liblmdb.a /usr/lib \
    ;; \
    fedora|centos) \
    yum update -y &&  dnf groupinstall -y 'Development Tools' && dnf install -y cmake leveldb-devel lmdb-devel openssl-devel libxml2-devel libyaml-devel libsqlite3x-devel mariadb-devel \
    ;; \
    ubuntu) \
    apt update -y && \
    apt install -y autoconf bison build-essential curl gawk git libleveldb-dev libleveldb1d liblmdb-dev libmysqlclient-dev libnss3-dev libsnappy1v5 libsqlite3-dev libssl-dev libxml2-dev libyaml-dev pkg-config python3 rsync texinfo zlib1g-dev rubygems \
    ;; \
    *) \
    echo "Unknown distro ${distro}" \
    exit 2\
    ;; \
    esac

FROM base as gambit
ENV GAMBIT_HOME=/opt/gambit
ENV GERBIL_BUILD_CORES=16
ENV GERBIL_HOME=/opt/gerbil
ENV GERBIL_PATH=/src/.gerbil
ENV PATH=${GAMBIT_HOME}/bin:${GERBIL_HOME}/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
RUN git config --global url.https://github.com/.insteadOf git://github.com/
RUN cd /opt && git clone https://github.com/gambit/gambit gambit-src
RUN cd /opt/gambit-src && git fetch -a
RUN cd /opt/gambit-src \
    && git fetch -a \
    && git checkout ${GAMBIT_VERSION} \
    && ./configure CC='gcc -D___SUPPORT_LOWLEVEL_EXEC' \
    --enable-default-runtime-options=f8,-8,t8 \
    --enable-targets=js,ruby,python \
    --enable-poll \
    --enable-openssl \
    --enable-default-compile-options="(compactness 9)" \
    --enable-multiple-versions \
    --enable-single-host \
    --prefix=${GAMBIT_HOME}
RUN cd /opt/gambit-src && make -j${GERBIL_BUILD_CORES}
RUN cd /opt/gambit-src && make bootstrap
RUN cd /opt/gambit-src && make bootclean
RUN cd /opt/gambit-src && make -j${GERBIL_BUILD_CORES}
RUN cd /opt/gambit-src && make -j${GERBIL_BUILD_CORES} modules
RUN cd /opt/gambit-src && make install

FROM gambit as gerbil
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

FROM gerbil as final
ARG GERBIL_VERSION
ARG GAMBIT_VERSION
RUN rm -rf /opt/gerbil-src /opt/gambit-src
RUN tar -czvf /gerbil-gambit.tgz /opt

WORKDIR /src
CMD ["gxi"]
