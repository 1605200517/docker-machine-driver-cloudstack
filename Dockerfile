FROM registry.gitlab.cc-asp.fraunhofer.de:4567/dockerimages/debian-go-sid:latest
COPY . /work/
RUN apt-get update && apt-get -y install wget && wget https://github.com/goreleaser/goreleaser/releases/download/v0.117.1/goreleaser_amd64.deb
RUN dpkg -i goreleaser_amd64.deb
RUN ls -alh 
RUN goreleaser --snapshot --skip-publish --rm-dist
