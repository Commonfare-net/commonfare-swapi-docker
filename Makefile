.PHONY: clean fetch docker/build docker/push

REPO=github.com/Commonfare-net/social-wallet-api
DEPS=./deps
SWAPISRC=${DEPS}/${REPO}
IMAGE="commonfare/social-wallet-api"

$(shell [ -d ${SWAPISRC} ] && true || git clone https://${REPO} ${SWAPISRC})

TAG ?= $(shell cd ${SWAPISRC} && git describe --tag)
VERSION ?= $(shell echo ${TAG} | cut -d'-' -f 1)

clean:
	rm -rf ${DEPS}/*

fetch:
	cd ${SWAPISRC} && git checkout master && git reset --hard && git pull && git checkout master && git checkout ${VERSION}

docker/build: fetch
	docker build . -t ${IMAGE}:${VERSION}
	docker tag ${IMAGE}:${VERSION} ${IMAGE}:latest

docker/push: docker/build
	docker push ${IMAGE}:${VERSION}
	docker push ${IMAGE}:latest


all: fetch docker/build
