from centos:centos7

MAINTAINER gerbil@cons.io

ARG squid
#ENV https_proxy=https://${squid}:3128
#ENV http_proxy=http://${squid}:3128

RUN yum groupinstall -y 'Development Tools'
RUN yum install epel-release
RUN yum update -y
RUN yum install -y openssl-devel sqlite-devel leveldb-devel leveldb lmdb-devel mariadb-devel libyaml-devel libxml2-devel
