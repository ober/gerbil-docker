from centos:centos7

MAINTAINER gerbil@cons.io

ARG squid

ENV all_proxy=http://${squid}:3128
ENV httpd_proxy=http://${squid}:3128
ENV http_proxy=http://${squid}:3128
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y epel-release
RUN yum update -y
RUN yum install -y openssl-devel sqlite-devel leveldb-devel leveldb lmdb-devel mariadb-devel libyaml-devel libxml2-devel openssl-static libyaml-devel glibc-static openssl11-static zlib-static
RUN curl -k -L -o /tmp/yaml.tgz https://github.com/yaml/libyaml/archive/0.2.4/libyaml-dist-0.2.4.tar.gz && cd /tmp && tar -xf yaml.tgz && cd libyaml-0* && ./bootstrap && ./configure --prefix=/usr && make -j4 && make install
RUN curl -k -L -o /tmp/openssl.tgz https://openssl.org/source/openssl-1.1.0f.tar.gz && cd /tmp && tar -xf openssl.tgz && cd openssl-* && ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic && make && make install
