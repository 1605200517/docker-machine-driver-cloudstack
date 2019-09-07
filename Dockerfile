
FROM debian:sid as baseimage

RUN apt -y update && apt -y install wget curl git nano &&\
    apt-get -y install rpm librpmbuild8 golang-go build-essential &&\
    go version &&\
    wget https://github.com/goreleaser/goreleaser/releases/download/v0.117.2/goreleaser_amd64.deb &&\
    dpkg -i goreleaser_amd64.deb && rm -f goreleaser_amd64.deb &&\
    mkdir -p /root/go/bin && mkdir /root/go/src/ &&\
    curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh &&\
    mv /root/go/bin/dep /usr/bin/ && dep version

WORKDIR /root/go/src/


FROM baseimage as builder
COPY . /root/go/src/app/
WORKDIR /root/go/src/app/
RUN ls -alh
RUN dep ensure &&\
    goreleaser --snapshot --skip-publish && ls -alh dist/


FROM ubuntu:latest
WORKDIR /test/
COPY --from=builder /root/go/src/app/dist/docker-machine-driver-cloudstack_docker-machine-driver-cloudstack-next_linux_amd64.deb /test/dm-cs-amd64.deb
RUN apt -y update && apt -y install curl &&\
    base=https://github.com/docker/machine/releases/download/v0.16.0 &&\
    curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&\
    mv /tmp/docker-machine /usr/local/bin/docker-machine &&\
    chmod +x /usr/local/bin/docker-machine &&\
    docker-machine --version &&\
    dpkg -i ./dm-cs-amd64.deb
