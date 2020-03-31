FROM ubuntu:18.04

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get -q update \
 && apt-get -qy --no-install-recommends install wget \
 && rm -rf /var/lib/apt/lists/* \
 && echo '#!/bin/bash' > /usr/bin/fme-install \
 && echo 'set -ex' >> /usr/bin/fme-install \
 && echo 'debfile="$(basename ${FME_DOWNLOAD#https:/})"' >> /usr/bin/fme-install \
 && echo 'package="$(dpkg --field "$debfile" package)"' >> /usr/bin/fme-install \
 && echo 'date="$(date +%F)"' >> /usr/bin/fme-install \
 && echo 'rm -f "$debfile"' >> /usr/bin/fme-install \
 && echo 'wget --no-check-certificate "$FME_DOWNLOAD"' >> /usr/bin/fme-install \
 && echo 'mkdir -p old_installs' >> /usr/bin/fme-install \
 && echo '[ -e "/opt/fme" ] && mv /opt/fme old_installs/$date' >> /usr/bin/fme-install \
 && echo 'dpkg --install --ignore-depends=$package "$debfile"' >> /usr/bin/fme-install \
 && echo 'mv "/opt/$package" /opt/fme' >> /usr/bin/fme-install \
 && chmod u+x /usr/bin/fme-install

ENV FME_DOWNLOAD="https://downloads.safe.com/fme/2020/fme-desktop-2020_2020.0.0.1.20202~ubuntu.18.04_amd64.deb"

WORKDIR /fme-install

CMD ["fme-install"]
