FROM ubuntu:16.04


ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y ubuntu-server wget sudo && \
    add-apt-repository ppa:bigbluebutton/support -y && \
    add-apt-repository ppa:rmescandon/yq -y && \
    apt-get dist-upgrade && \
    wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | sudo apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    apt-get update && \
    apt-get install -y mongodb-org curl && \
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
    apt-get install -y nodejs && \
    wget https://ubuntu.bigbluebutton.org/repo/bigbluebutton.asc -O- | sudo apt-key add - && \
    echo "deb https://ubuntu.bigbluebutton.org/xenial-220/ bigbluebutton-xenial main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list && \
    apt-get update && \
    apt-get install -y bigbluebutton bbb-html5