from jaimef/centos:latest

RUN curl -k -L -o /tmp/yaml.tgz https://github.com/yaml/libyaml/archive/0.2.4/libyaml-dist-0.2.4.tar.gz
RUN cd /tmp && tar -xf yaml.tgz && cd libyaml-0* && ./bootstrap && ./configure --prefix=/usr && make -j4 && make install
RUN yum install -y zlib-static openssl-static libyaml-devel glibc-static
