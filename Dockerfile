FROM ubuntu:focal

ARG NS3_VERSION=3.32
ARG DEBIAN_FRONTEND=noninteractive
ARG BUILD_PROFILE=debug

LABEL org.opencontainers.version="v1.0.0"
LABEL org.opencontainers.image.authors="Marshall Asch <masch@uoguelph.ca> (https://marshallasch.ca)"
LABEL org.opencontainers.image.url="https://github.com/MarshallAsch/ns3-container.git"
LABEL org.opencontainers.image.source="https://github.com/MarshallAsch/ns3-container.git"
LABEL org.opencontainers.image.vendor="Marshall Asch"
LABEL org.opencontainers.image.licenses="ISC"
LABEL org.opencontainers.image.title="ns-3 docker container"
LABEL org.opencontainers.image.description="ns-3 base docker container"

WORKDIR /ns3

ENTRYPOINT ["/ns3/entrypoint.sh"]

RUN apt-get update && apt-get install -y \
    g++ \
    python3-dev \
    pkg-config \
    sqlite \
    sqlite3 \
    libsqlite3-dev \
    python3-setuptools \
    git \
    autoconf \
    cvs \
    bzr \
    unrar \
    libxml2-dev \
    make \
    cmake \
    build-essential \
    unzip \
    wget \
    qt5-default \
    python3-gi-cairo \
    gir1.2-gtk-3.0 \
    python3-gi \
    python3-pygraphviz \
    gsl-bin \
    libgsl0-dev

RUN wget http://www.nsnam.org/release/ns-allinone-${NS3_VERSION}.tar.bz2 && \
    tar xjf ns-allinone-${NS3_VERSION}.tar.bz2

ENV BUILD_PROFILE=$BUILD_PROFILE
ENV NS3_VERSION=$NS3_VERSION
ENV NS3_ROOT=/ns3/ns-allinone-${NS3_VERSION}/ns-${NS3_VERSION}

COPY entrypoint.sh entrypoint.sh

WORKDIR ns-allinone-${NS3_VERSION}/ns-${NS3_VERSION}

RUN ./waf configure --enable-examples --enable-tests --build-profile=${BUILD_PROFILE}  && ./waf build

# these two labels will change every time the container is built
# put them at the end because of layer caching
ARG VCS_REF
LABEL org.opencontainers.image.revision="${VCS_REF}"

ARG BUILD_DATE
LABEL org.opencontainers.image.created="${BUILD_DATE}"
