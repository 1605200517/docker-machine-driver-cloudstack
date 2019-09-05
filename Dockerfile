FROM registry.gitlab.cc-asp.fraunhofer.de:4567/dockerimages/debian-go-sid:latest
COPY . /work/
RUN ls -alh 
RUN goreleaser --snapshot --skip-publish --rm-dist
