FROM registry.gitlab.cc-asp.fraunhofer.de:4567/dockerimages/debian-go-sid:latest
COPY . /root/go/src/app/
WORKDIR /root/go/src/app/
RUN apt-get update && apt-get -y install rpm librpmbuild8
RUN ls -alh 
RUN dep ensure &&\
    goreleaser --snapshot --skip-publish --rm-dist
