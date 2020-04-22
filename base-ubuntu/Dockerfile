from ubuntu:latest

MAINTAINER gerbil@cons.io

ARG squid
ENV DEBIAN_FRONTEND=noninteractive
ENV https_proxy=https://${squid}:3128
ENV http_proxy=http://${squid}:3128
RUN apt update -y
RUN apt install -y libsqlite3-dev build-essential git autoconf libblas3 wget sudo lsb-release tmux tzdata libsnappy1v5  libleveldb1v5 zsh zlib1g-dev libssl-dev x11-xserver-utils pkg-config libffi-dev libffi6 gfortran libblas-dev liblapack-dev libyaml-dev libmysqlclient-dev liblmdb-dev libleveldb-dev
