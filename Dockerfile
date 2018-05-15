FROM clojure

ARG SRC=./deps/github.com/Commonfare-net/social-wallet-api

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY ${SRC} /usr/src/app
RUN lein deps
COPY . /usr/src/app
# CMD ["lein", "ring", "server-headless"]
ENTRYPOINT [ "lein", "ring", "server-headless" ]