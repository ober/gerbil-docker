.PHONY: docker base-centos base-ubuntu centos ubuntu base-fedora fedora centos-static alpine-static alpine-current-static alpine-current-jedi ubuntu-current-jedi

#$(eval squid_ip := $(shell docker inspect squid|jq -r '.[].NetworkSettings.IPAddress'))

incremental:
	docker build --build-arg squid=$(squid_ip) --rm=true -t gerbil-scheme .
	docker tag gerbil-scheme gerbil-scheme:latest

ubuntu:
	docker build --build-arg squid=$(squid_ip) --rm=true --no-cache -t gerbil-scheme ./ubuntu
	docker tag gerbil-scheme gerbil/scheme:ubuntu

centos:
	docker build --build-arg squid=$(squid_ip) -t centos ./centos
	docker tag centos jaimef/centos

ubuntu-current-jedi:
	docker build --rm=true --no-cache -t ubuntu-current-jedi ./ubuntu-current-jedi
	docker tag ubuntu-current-jedi jaimef/jedi:ubuntu

base-ubuntu:
	docker build --build-arg squid=$(squid_ip) --rm=true --build-arg squid=$(squid_ip) --no-cache -t gerbil-base ./base-ubuntu
	docker tag gerbil-base gerbil/base:ubuntu

gerbil-gambit:
	docker build --build-arg squid=$(squid_ip) --rm=true --build-arg squid=$(squid_ip) --no-cache -t gerbil-gambit ./official
	docker tag gerbil-gambit gerbil/gambit
	docker push gerbil/gambit

base-centos:
	docker build --build-arg squid=$(squid_ip) --rm=true --no-cache -t base-centos ./base-centos
	docker tag base-centos jaimef/base:centos

centos-static:
	docker build --build-arg squid=$(squid_ip) --rm=true --no-cache -t centos-static ./centos-static
	docker tag centos-static jaimef/centos:static

alpine-static:
	docker build --rm=true --no-cache -t alpine-static ./alpine-static
	docker tag alpine-static jaimef/alpine:static

alpine-current-static:
	docker build --rm=true --no-cache -t alpine-current-static ./alpine-current-static
	#docker build -t alpine-current-static ./alpine-current-static
	docker tag alpine-current-static jaimef/alpine-current:static

alpine-current-jedi:
	#docker build --rm=true --no-cache -t alpine-current-jedi ./alpine-current-jedi
	docker build -t alpine-current-jedi ./alpine-current-jedi
	docker tag alpine-current-jedi jaimef/alpine-current-jedi:static

base-fedora:
	docker build --build-arg squid=$(squid_ip) --rm=true --no-cache -t gerbil-base ./base-fedora
	docker tag gerbil-base gerbil/base:fedora

push-all:
	docker push jaimef/base:centos
	docker push jaimef/centos
	docker push jaimef/centos:static


docker: ubuntu
