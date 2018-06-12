FROM clojure

ARG SRC=./deps/github.com/Commonfare-net/social-wallet-api
ENV SWAPI_PORT=3000

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ${SRC} /usr/src/app
#RUN lein deps

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
