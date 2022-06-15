.PHONY: docker base-centos base-ubuntu centos ubuntu base-fedora fedora centos-static alpine-static alpine-current-static alpine-current-jedi ubuntu-current-jedi final

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

$(eval squid_ip := $(shell docker inspect squid|jq -r '.[].NetworkSettings.IPAddress'))
$(info $(squid_ip) is squid)

alpine:
	docker build --target final --build-arg squid=$(squid_ip) --build-arg distro="alpine" -t final $(ROOT_DIR)
	docker tag final jaimef/gerbil-alpine

centos:
	docker build --target final --build-arg squid=$(squid_ip) --build-arg distro="centos" -t final $(ROOT_DIR)
	docker tag final jaimef/gerbil-centos

fedora:
	docker build --target final --build-arg squid=$(squid_ip) --build-arg distro="fedora" -t final $(ROOT_DIR)
	docker tag final jaimef/gerbil-fedora

ubuntu:
	docker build --target final --build-arg squid=$(squid_ip) --build-arg distro="ubuntu" -t final $(ROOT_DIR)
	docker tag final jaimef/gerbil-ubuntu
    docker run -v $(PWD):/src -t jaimef/gerbil-ubuntu "mv /opt/"

ubuntu-current-jedi:
	docker build --rm=true --no-cache -t ubuntu-current-jedi $(ROOT_DIR)/ubuntu-current-jedi
	docker tag ubuntu-current-jedi jaimef/jedi:ubuntu

push-all:
	docker push jaimef/base:centos
	docker push jaimef/centos
	docker push jaimef/centos:static


docker: ubuntu
