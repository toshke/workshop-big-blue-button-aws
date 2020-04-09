#!/usr/bin/env bash

DEBIAN_FRONTEND=noninteractive

mkdir -p /tmp/bbb-install && \
    cd /tmp/bbb-install && \
    wget https://ubuntu.bigbluebutton.org/bbb-install.sh  && \
    chmod a+x bbb-install.sh && \
    ./bbb-install.sh -v xenial-220 -s ${DOMAIN_NAME} -e ${ADMIN_EMAIL} -l -g

bbb-conf --stop
bbb-conf --start
