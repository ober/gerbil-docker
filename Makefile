.PHONY: docker base-centos base-ubuntu centos ubuntu base-fedora fedora

$(eval squid_ip := $(shell docker inspect squid|jq -r '.[].NetworkSettings.IPAddress'))

incremental:
	docker build --build-arg squid=$(squid_ip) --rm=true -t gerbil-scheme .
	docker tag gerbil-scheme gerbil-scheme:latest

ubuntu:
	docker build --build-arg squid=$(squid_ip) --rm=true --no-cache -t gerbil-scheme ./ubuntu
	docker tag gerbil-scheme gerbil/scheme:ubuntu

centos:
	docker build --build-arg squid=$(squid_ip) -t centos ./centos
	docker tag gerbil-scheme jaimef/centos

base-ubuntu:
	docker build --build-arg squid=$(squid_ip) --rm=true --build-arg squid=$(squid_ip) --no-cache -t gerbil-base ./base-ubuntu
	docker tag gerbil-base gerbil/base:ubuntu

gerbil-gambit:
	docker build --build-arg squid=$(squid_ip) --rm=true --build-arg squid=$(squid_ip) --no-cache -t gerbil-gambit ./official
	docker tag gerbil-gambit gerbil/gambit

base-centos:
	docker build --build-arg squid=$(squid_ip)  --rm=true --no-cache -t base-centos ./base-centos
	docker tag gerbil-base jaimef/base:centos

base-fedora:
	docker build --build-arg squid=$(squid_ip)  --rm=true --no-cache -t gerbil-base ./base-fedora
	docker tag gerbil-base gerbil/base:fedora


push-all:
	docker push jaimef/base:centos
	docker push jaimef/base:ubuntu
	docker push jaimef/centos
	docker push jaimef/ubuntu

docker: ubuntu
