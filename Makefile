.PHONY: docker base-centos base-ubuntu centos ubuntu base-fedora fedora centos-static alpine-static alpine-current-static alpine-current-jedi ubuntu-current-jedi final

GERBIL_VERSION := v0.17.0
GAMBIT_VERSION := v4.9.4

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

#$(eval squid_ip := $(shell docker inspect squid|jq -r '.[].NetworkSettings.IPAddress'))
$(info $(squid_ip) is squid)

alpine:
	docker build --target final --build-arg squid=$(squid_ip) --build-arg distro="alpine" -t final $(ROOT_DIR)
	docker tag final uaptf/gerbil-alpine

centos:
	docker build --target final --build-arg squid=$(squid_ip) --build-arg distro="centos" -t final $(ROOT_DIR)
	docker tag final uaptf/gerbil-centos

fedora:
	docker build --target final --build-arg squid=$(squid_ip) --build-arg distro="fedora" -t final $(ROOT_DIR)
	docker tag final uaptf/gerbil-fedora

amazonlinux:
	docker build --target final --build-arg squid=$(squid_ip) --build-arg distro="amazonlinux" -t final $(ROOT_DIR)
	docker tag final uaptf/gerbil-amazonlinux

ubuntu:
	docker build --target final --build-arg squid=$(squid_ip) --build-arg distro="ubuntu" -t final $(ROOT_DIR)
	docker tag final uaptf/gerbil-ubuntu
	docker run -t uaptf/gerbil-ubuntu

ubuntu-current-jedi:
	docker build --rm=true --no-cache -t ubuntu-current-jedi $(ROOT_DIR)/ubuntu-current-jedi
	docker tag ubuntu-current-jedi uaptf/jedi:ubuntu

package-ubuntu:
	docker run -v $(PWD):/src -t uaptf/gerbil-ubuntu bash -c "gem install fpm && fpm -s dir -p /src/ -t deb -n gerbil-$(GERBIL_VERSION)-gambit-$(GAMBIT_VERSION) --description 'Gambit and Gerbil Package' /opt/gerbil /opt/gambit"

package-fedora:
	docker run -v $(PWD):/src -t uaptf/gerbil-fedora bash -c "yum install -y rubygems ruby-devel rpm-build && gem install fpm && fpm -s dir -p /src/ -t rpm -n gerbil-$(GERBIL_VERSION)-gambit-$(GAMBIT_VERSION) --description 'Gambit and Gerbil Package' /opt/gerbil /opt/gambit"

push-all: all
	docker push uaptf/alpine
	docker push uaptf/ubuntu
	docker push uaptf/fedora
	docker push uaptf/centos

all: alpine centos fedora ubuntu

docker: ubuntu
