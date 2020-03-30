FROM ubuntu:18.04

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get -q update \
 && apt-get -qy --no-install-recommends install wget \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /fme-upgrade/old_install \
 && echo '#!/bin/bash' > /usr/bin/fme-upgrade \
 && echo 'wget "$FME_DOWNLOAD"' >> /usr/bin/fme-upgrade \
 && echo '[ -n "$(ls /opt/fme*)" ] && mv /opt/fme* old_install/' >> /usr/bin/fme-upgrade \
 && echo 'dpkg --install $(basename ${FME_DOWNLOAD#https:/})' >> /usr/bin/fme-upgrade \
 && chmod u+x /usr/bin/fme-upgrade

ENV FME_DOWNLOAD="https://downloads.safe.com/fme/2020/fme-desktop-2020_2020.0.0.1.20202~ubuntu.18.04_amd64.deb"

WORKDIR /fme-upgrade

CMD ["fme-upgrade"]
