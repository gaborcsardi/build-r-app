FROM ubuntu:24.04

RUN apt-get update && \
    apt-get -y install docker.io docker-buildx && \
    apt-get clean

COPY entrypoint.sh /entrypoint.sh
RUN mkdir /builder
COPY Dockerfile-build /builder/Dockerfile

ENTRYPOINT ["/entrypoint.sh"]
