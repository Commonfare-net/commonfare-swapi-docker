# Dockerize Commonfare Social Wallet API
The purpose of this project is to create a docker image of the
Commonfare Social Wallet API service: https://github.com/Commonfare-net/social-wallet-api

## How it works
At a glance this is very simple and consists of the follwing steps:
 1. Clone the source repository of Commonfare Social Wallet API (a.k.a SWAPI)
 2. Build a dedicated image through the Dockerfile for running SWAPI service which includes all the required Clojure/Lein/Java dependencies
 3. Push such image to Docker Hub

## How to use it
There is a `Makefile` that should help out when building a new image.

### Build target
Command `make docker/build` should build the image according to the provided `Dockerfile` and
generate the final docker image named _commonfare/social-wallet-api_.  
The image is also tagged with the git tag of the original repository:
```
$ docker images
REPOSITORY                            TAG                 IMAGE ID            CREATED             SIZE
commonfare/social-wallet-api          latest              c179ea2bd09c        8 minutes ago       767MB
commonfare/social-wallet-api          v0.9.3              c179ea2bd09c        8 minutes ago       767MB
```
### Update SWAPI version
If you need to update to a new version of the SWAPI service (https://github.com/Commonfare-net/social-wallet-api) please make sure
to cleanup the source directory first by using the command `make clean` and then to rebuild the docker image you can use `make docker/build`.

### Push target
Command `make docker/push` will push the image to Docker Hub and make it publicly available

## Known issues and plan
 - At the time of writing the first time this image is run, all dependencies will be downloaded.  This is not really nice and clean so it shoul be avoided. Most probably
 docker multistage build might help here.

 - The size of the image is way too large (~760MB) and again this is not good. The plan is to 
 use docker multistage feature and to build a stnadalone jar file to be run in a tiny image
 running only an application container and this jar file.