#!/usr/bin/env bash

DEBIAN_FRONTEND=noninteractive

mkdir -p /tmp/bbb-install && \
    cd /tmp/bbb-install && \
    wget https://raw.githubusercontent.com/bigbluebutton/bbb-install/master/bbb-install.sh && \
    chmod a+x bbb-install.sh && \
    ./bbb-install.sh  -v xenial-220

# configuration
export HOSTNAME=${DOMAIN_NAME}
export PATH=${PATH}:/usr/bin

# trust let's encrypt certificates
mkdir -p /usr/share/ca-certificates/letsencrypt.org && \
    cd /usr/share/ca-certificates/letsencrypt.org && \
    wget "https://letsencrypt.org/certs/isrgrootx1.pem" && \
    update-ca-certificates

# allow ports
ufw allow 80
ufw allow 443
ufw allow 7443

# obtain let's encrypt ssl certificate
apt-get install -q letsencrypt && \
    certbot certonly --standalone --preferred-challenges http -d ${DOMAIN_NAME} && \
    cp /etc/letsencrypt/live/${DOMAIN_NAME}/fullchain.pem \
        /etc/nginx/ssl/${DOMAIN_NAME}.crt &&
    cp /etc/letsencrypt/live/${DOMAIN_NAME}/privkey.pem \
        /etc/nginx/ssl/${DOMAIN_NAME}.key

# configure nginx to use the cert
ed /etc/nginx/sites-available/bigbluebutton  << END
3i
    listen 443 ssl;
    listen [::]:443 ssl;

    ssl_certificate /etc/nginx/ssl/${DOMAIN_NAME}.crt;
    ssl_certificate_key /etc/nginx/ssl/${DOMAIN_NAME}.key;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers "ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS:!AES256";
    ssl_prefer_server_ciphers on;
    ssl_dhparam /etc/nginx/ssl/dhp-4096.pem;
.
w
q
END
openssl dhparam -out /etc/nginx/ssl/dhp-4096.pem 4096

sed -i "s/http:\/\/${DOMAIN_NAME}/https:\/\/${DOMAIN_NAME}/g" /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sed -i "s/http:\/\/${DOMAIN_NAME}/https:\/\/${DOMAIN_NAME}/g" /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties
sed -i "s/http:\/\/${DOMAIN_NAME}/https:\/\/${DOMAIN_NAME}/g" /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
sed -i "s/http:\/\/${DOMAIN_NAME}/https:\/\/${DOMAIN_NAME}/g" /var/lib/tomcat7/webapps/demo/bbb_api_conf.jsp

sed -e 's|http://|https://|g' -i /var/www/bigbluebutton/client/conf/config.xml
sed -i "s/ws:\//wss:\//g" /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
sed -i "s/playback_protocol: http/playback_protocol: https/g" /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml

apt-get --assume-yes install  -qq bbb-demo

ufw disable

bbb-conf --setip ${DOMAIN_NAME}
bbb-conf --restart
