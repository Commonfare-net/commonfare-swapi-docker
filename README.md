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
### Push target
Command `make docker/push` will push the image to Docker Hub and make it publicly available

### Fix target
The `fix` target is a temporary solution that is in charge to comment out a line in the source
code of the Social Wallet API before building the image.  
Such line is in the project file `project.clj` and instructs the ring web server to listen only
on the `localhost` hostname.

```
  :ring {:init    social-wallet-api.handler/init
         :handler social-wallet-api.handler/app
         ;; Accessible only from localhost
         ;; https://stackoverflow.com/questions/24467539/lein-ring-server-headless-only-listen-to-localhost
         :host "localhost"
         :destroy social-wallet-api.handler/destroy
         :reload-paths ["src"]}
```

If we leave such line there we will need to use docker `host` network in order to reach the
service through (for example) `localhost:3000`.  
As we prefer not to get container services directly using the host netwroking rather relying on
their private container network we'd like to avoid it. But to do so and still be able to reach
the container after some port mapping such as `<host port>:<container port>`, we need to allow
the services to listen on other hostnames too.  

So after running the `fix` target we will get the following ad are good to go with buidling the image.

```
  :ring {:init    social-wallet-api.handler/init
         :handler social-wallet-api.handler/app
         ;; Accessible only from localhost
         ;; https://stackoverflow.com/questions/24467539/lein-ring-server-headless-only-listen-to-localhost
         ;;:host "localhost"
         :destroy social-wallet-api.handler/destroy
         :reload-paths ["src"]}
```