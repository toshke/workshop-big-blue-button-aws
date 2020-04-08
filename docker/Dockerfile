FROM ubuntu:16.04


COPY server_install_input.txt /server_install_input.txt


RUN apt-get update

ENV DEBIAN_FRONTEND=noninteractive
RUN cat /server_install_input.txt | apt-get --assume-yes install -q ubuntu-server wget sudo

RUN mkdir -p /tmp/bbb-install && \
        cd /tmp/bbb-install && \
        wget https://raw.githubusercontent.com/bigbluebutton/bbb-install/master/bbb-install.sh && \
        chmod a+x bbb-install.sh && \
        ./bbb-install.sh  -v xenial-220