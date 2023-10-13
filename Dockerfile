ARG UBUNTU_RELEASE=23.10
FROM ubuntu:${UBUNTU_RELEASE}

ARG UBUNTU_RELEASE=23.10
COPY apt-install.ubuntu-${UBUNTU_RELEASE}.sh /tmp/apt-install.sh

RUN sh /tmp/apt-install.sh
