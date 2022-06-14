.PHONY: docker base-centos base-ubuntu centos ubuntu base-fedora fedora centos-static alpine-static alpine-current-static alpine-current-jedi ubuntu-current-jedi final

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

#$(eval squid_ip := $(shell docker inspect squid|jq -r '.[].NetworkSettings.IPAddress'))

incremental:
	docker build --build-arg squid=$(squid_ip) --rm=true -t gerbil-scheme .
	docker tag gerbil-scheme gerbil-scheme:latest

ubuntu:
	docker build --build-arg squid=$(squid_ip) --rm=true --no-cache -t gerbil-scheme $(ROOT_DIR)/ubuntu
	docker tag gerbil-scheme gerbil/scheme:ubuntu

centos:
	docker build --build-arg squid=$(squid_ip) -t centos $(ROOT_DIR)/centos/
	docker tag centos jaimef/centos

fedora:
	docker build -t fedora-gambit $(ROOT_DIR)/fedora
	docker tag centos jaimef/fedora-gambit


final:
	docker build --target final --build-arg distro="fedora" -t final $(ROOT_DIR)/final
	docker tag final jaimef/gerbil-final

ubuntu-current-jedi:

	docker build --rm=true --no-cache -t ubuntu-current-jedi $(ROOT_DIR)/ubuntu-current-jedi
	docker tag ubuntu-current-jedi jaimef/jedi:ubuntu

base-ubuntu:
	docker build --rm=true --build-arg squid=$(squid_ip) --no-cache -t gerbil-base $(ROOT_DIR)/base-ubuntu
	docker tag gerbil-base gerbil/base:ubuntu

gerbil-gambit:
	docker build --rm=true --build-arg squid=$(squid_ip) --no-cache -t gerbil-gambit $(ROOT_DIR)/official
	docker tag gerbil-gambit gerbil/gambit
	docker push gerbil/gambit

base-centos:
	docker build --build-arg squid=$(squid_ip) --rm=true --no-cache -t base-centos $(ROOT_DIR)/base-centos
	docker tag base-centos jaimef/base:centos

centos-static:
	docker build --build-arg squid=$(squid_ip) --rm=true --no-cache -t centos-static $(ROOT_DIR)/centos-static
	docker tag centos-static jaimef/centos:static

alpine-static:
	docker build --rm=true --no-cache -t alpine-static $(ROOT_DIR)/alpine-static
	docker tag alpine-static jaimef/alpine:static

alpine-current-static:
	docker build --rm=true --no-cache -t alpine-current-static $(ROOT_DIR)/alpine-current-static/
	#docker build -t alpine-current-static $(ROOT_DIR)/alpine-current-static
	docker tag alpine-current-static jaimef/alpine-current:static

alpine-current-jedi:
	#docker build --rm=true --no-cache -t alpine-current-jedi $(ROOT_DIR)/alpine-current-jedi
	docker build -t alpine-current-jedi $(ROOT_DIR)/alpine-current-jedi
	docker tag alpine-current-jedi jaimef/alpine-current-jedi:static

base-fedora:
	docker build --build-arg squid=$(squid_ip) --rm=true --no-cache -t gerbil-base $(ROOT_DIR)/base-fedora
	docker tag gerbil-base gerbil/base:fedora

push-all:
	docker push jaimef/base:centos
	docker push jaimef/centos
	docker push jaimef/centos:static


docker: ubuntu
