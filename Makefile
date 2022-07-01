.PHONY: docker base-centos base-ubuntu centos ubuntu base-fedora fedora centos-static alpine-static alpine-current-static alpine-current-jedi ubuntu-current-jedi final

GERBIL_VERSION := v0.17.0
GAMBIT_VERSION := v4.9.4

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
cores := $(shell grep -c "^processor" /proc/cpuinfo)

#$(eval squid_ip := $(shell docker inspect squid|jq -r '.[].NetworkSettings.IPAddress'))
#$(info $(squid_ip) is squid)

alpine: packages := autoconf automake cmake curl g++ gcc git libgcc libtool leveldb-dev lmdb-dev libxml2-dev linux-headers make mariadb-dev musl musl-dev nodejs openssl-dev openssl-libs-static ruby sqlite-dev yaml-dev yaml-static zlib-static
alpine:
	docker build --target final --build-arg packages="$(packages)" --build-arg cores=$(cores) --build-arg distro="alpine" -t final $(ROOT_DIR)
	docker tag final gerbil/alpine

amazonlinux:
	docker build --target final --build-arg squid=$(squid_ip) --build-arg distro="amazonlinux" -t final $(ROOT_DIR)
	docker tag final gerbil/amazonlinux

centos:
	docker build --target final --build-arg squid=$(squid_ip) --build-arg distro="centos" -t final $(ROOT_DIR)
	docker tag final gerbil/centos

fedora: packages := cmake leveldb-devel lmdb-devel openssl-devel libxml2-devel libyaml-devel libsqlite3x-devel mariadb-devel mariadb-libs sqlite-devel
fedora:
	docker build --target final --build-arg packages="$(packages)" --build-arg cores=$(cores) --build-arg distro="fedora" -t final $(ROOT_DIR)
	docker tag final gerbil/fedora

ubuntu: packages := autoconf bison build-essential curl gawk git libleveldb-dev libleveldb1d liblmdb-dev libmysqlclient-dev libnss3-dev libsnappy1v5 libsqlite3-dev libssl-dev libxml2-dev libyaml-dev pkg-config python3 rsync texinfo zlib1g-dev rubygems
ubuntu:
	docker build --target final --build-arg packages="$(packages)" --build-arg cores=$(cores) --build-arg distro="ubuntu" -t final $(ROOT_DIR)
	docker tag final gerbil/ubuntu

ubuntu-current-jedi:
	docker build --rm=true --no-cache -t ubuntu-current-jedi $(ROOT_DIR)/ubuntu-current-jedi
	docker tag ubuntu-current-jedi gerbil/jedi:ubuntu

package-ubuntu:
	docker run -v $(PWD):/src -t gerbil/ubuntu bash -c "gem install fpm && fpm -s dir -p /src/ -t deb -n gerbil-$(GERBIL_VERSION)-gambit-$(GAMBIT_VERSION) --description 'Gambit and Gerbil Package' /opt/gerbil /opt/gambit"

package-fedora:
	docker run -v $(PWD):/src -t gerbil/fedora bash -c "yum install -y rubygems ruby-devel rpm-build && gem install fpm && fpm -s dir -p /src/ -t rpm -n gerbil-$(GERBIL_VERSION)-gambit-$(GAMBIT_VERSION) --description 'Gambit and Gerbil Package' /opt/gerbil /opt/gambit"

packages: package-ubuntu package-fedora

push-all: all
	docker push gerbil/alpine
	docker push gerbil/ubuntu
	docker push gerbil/fedora
	docker push gerbil/centos

all: alpine centos fedora ubuntu

docker: ubuntu
