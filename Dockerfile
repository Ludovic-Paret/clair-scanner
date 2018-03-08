FROM alpine:3.7

ENV CLAIR_SCANNER v8

ARG RUNTIME_DEPS="docker"
ARG BUILD_DEPS="make go musl-dev git"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_DEPS} && \
    apk add --no-cache --virtual build-dependencies ${BUILD_DEPS} && \
    export GOPATH=/go && \
    export PATH=${GOPATH}/bin:${PATH} && \
    mkdir -p ${GOPATH}/src ${GOPATH}/bin && \
    cd /go/src && \
    git clone https://github.com/arminc/clair-scanner.git && \
    cd clair-scanner && \
    git checkout ${CLAIR_SCANNER} && \
    go get -u github.com/golang/dep/cmd/dep && \
    make ensure && \
    make build && \
    cp clair-scanner /usr/local/bin/clair-scanner && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* /tmp/* /go

ENTRYPOINT ["/usr/local/bin/clair-scanner"]
