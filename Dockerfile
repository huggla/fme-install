FROM ubuntu:18.04

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get -q update \
 && apt-get -qy --no-install-recommends install wget \
 && rm -rf /var/lib/apt/lists/* \
 && echo '#!/bin/bash' > /usr/bin/fme-upgrade \
 && echo 'fmePackage="$(basename ${FME_DOWNLOAD#https:/})"' >> /usr/bin/fme-upgrade \
 && echo 'date="$(date +%F)"' >> /usr/bin/fme-upgrade \
 && echo 'rm -f "$fmePackage"' >> /usr/bin/fme-upgrade \
 && echo 'wget --no-check-certificate "$FME_DOWNLOAD"' >> /usr/bin/fme-upgrade \
 && echo 'mkdir -p old_installs/$date' >> /usr/bin/fme-upgrade \
 && echo '[ -e "/opt/fme" ] && mv /opt/fme old_installs/$date' >> /usr/bin/fme-upgrade \
 && echo 'dpkg --install "$fmePackage"' >> /usr/bin/fme-upgrade \
 && chmod u+x /usr/bin/fme-upgrade

ENV FME_DOWNLOAD="https://downloads.safe.com/fme/2020/fme-desktop-2020_2020.0.0.1.20202~ubuntu.18.04_amd64.deb"

WORKDIR /fme-upgrade

CMD ["fme-upgrade"]
