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

# comment the line of code ':host "localhost"' in order to allow the service
# to listen on different names from localhost only
fix:
	mv ${SWAPISRC}/project.clj ${SWAPISRC}/project.clj.ORIGINAL
	cat ${SWAPISRC}/project.clj.ORIGINAL | sed 's/\(:host "localhost"\)/;;\1/' > ${SWAPISRC}/project.clj

docker/build: fetch fix
	docker build . -t ${IMAGE}:${VERSION}
	docker tag ${IMAGE}:${VERSION} ${IMAGE}:latest

docker/push: docker/build
	docker push ${IMAGE}:${VERSION}
	docker push ${IMAGE}:latest


all: fetch docker/build
