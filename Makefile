.PHONY: docker base-centos base-ubuntu centos ubuntu base-fedora fedora centos-static alpine-static alpine-current-static alpine-current-jedi ubuntu-current-jedi final

GERBIL_VERSION := v0.17.0
GAMBIT_VERSION := v4.9.4

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
cores := $(shell grep -c "^processor" /proc/cpuinfo)

#$(eval squid_ip := $(shell docker inspect squid|jq -r '.[].NetworkSettings.IPAddress'))
$(info $(cores) is cores)

alpine_packages := autoconf automake cmake curl g++ gcc git libgcc libtool leveldb-dev lmdb-dev libxml2-dev linux-headers make mariadb-dev musl musl-dev nodejs openssl-dev openssl-libs-static ruby sqlite-dev yaml-dev yaml-static zlib-static
amazon_packages := cmake leveldb-devel lmdb-devel openssl-devel libxml2-devel libyaml-devel libsqlite3x-devel mariadb-devel mariadb-libs sqlite-devel
fedora_packages := cmake leveldb-devel lmdb-devel openssl-devel libxml2-devel libyaml-devel libsqlite3x-devel mariadb-devel mariadb-libs sqlite-devel
ubuntu_packages := autoconf bison build-essential curl gawk git libleveldb-dev libleveldb1d liblmdb-dev libmysqlclient-dev libnss3-dev libsnappy1v5 libsqlite3-dev libssl-dev libxml2-dev libyaml-dev pkg-config python3 rsync texinfo zlib1g-dev rubygems

alpine:
	docker build --target final --build-arg packages="$(alpine_packages)" --build-arg cores=$(cores) --build-arg distro="alpine" -t final $(ROOT_DIR)
	docker tag final gerbil/alpine

amazonlinux:
	docker build --target final --build-arg packages="$(amazon_packages)" --build-arg cores=$(cores)  --build-arg distro="amazonlinux" -t final $(ROOT_DIR)
	docker tag final gerbil/amazonlinux

centos:
	docker build --target final --build-arg packages="$(centos_packages)" --build-arg cores=$(cores) --build-arg distro="centos" -t final $(ROOT_DIR)
	docker tag final gerbil/centos

fedora:
	docker build --target final --build-arg packages="$(packages)" --build-arg cores=$(cores) --build-arg distro="fedora" -t final $(ROOT_DIR)
	docker tag final gerbil/fedora

ubuntu:
	docker build --target final --build-arg packages="$(ubuntu_packages)" --build-arg cores=$(cores) --build-arg distro="ubuntu" -t final $(ROOT_DIR)
	docker tag final gerbil/ubuntu

ubuntu-current-jedi:
	docker build --rm=true --no-cache -t ubuntu-current-jedi $(ROOT_DIR)/ubuntu-current-jedi
	docker tag ubuntu-current-jedi gerbil/jedi:ubuntu

package-ubuntu:
	docker run -v $(PWD):/src -t gerbil/ubuntu bash -c "gem install fpm && fpm -s dir -p /src/ -t deb -n gerbil-$(gerbil_version)-gambit-$(gambit_version).ubuntu --description 'Gambit and Gerbil Package' /opt/gerbil /opt/gambit"

package-fedora:
	docker run -v $(PWD):/src -t gerbil/fedora bash -c "yum install -y rubygems ruby-devel rpm-build && gem install fpm && fpm -s dir -p /src/ -t rpm -n gerbil-$(gerbil_version)-gambit-$(gambit_version).fedora --description 'Gambit and Gerbil Package' /opt/gerbil /opt/gambit"

packages: package-ubuntu package-fedora

push-all: all
	docker push gerbil/alpine
	docker push gerbil/ubuntu
	docker push gerbil/fedora
	docker push gerbil/centos

all: alpine centos fedora ubuntu




docker: ubuntu
