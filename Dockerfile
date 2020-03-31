FROM ubuntu:18.04

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get -q update \
 && apt-get -qy --no-install-recommends install wget \
 && rm -rf /var/lib/apt/lists/* \
 && echo '#!/bin/bash' > /usr/bin/fme-install \
 && echo 'set -ex' >> /usr/bin/fme-install \
 && echo 'debfile="$(basename ${FME_DOWNLOAD#https:/})"' >> /usr/bin/fme-install \
 && echo 'date="$(date +%Y%m%d-%H.%M)"' >> /usr/bin/fme-install \
 && echo 'rm -f "$debfile"' >> /usr/bin/fme-install \
 && echo 'wget --no-verbose --no-check-certificate "$FME_DOWNLOAD"' >> /usr/bin/fme-install \
 && echo 'mkdir -p old_installs/$date /opt/fme' >> /usr/bin/fme-install \
 && echo 'ls -A /opt/fme | grep -q .' >> /usr/bin/fme-install \
 && echo '[ "$?" == "0" ] && mv --target-directory=old_installs/$date /opt/fme/*' >> /usr/bin/fme-install \
 && echo 'dpkg --unpack "$debfile"' >> /usr/bin/fme-install \
 && echo 'package="$(dpkg --field "$debfile" package)"' >> /usr/bin/fme-install \
 && echo 'mv --target-directory=/opt/fme /opt/$package/*' >> /usr/bin/fme-install \
 && echo 'rmdir /opt/$package' >> /usr/bin/fme-install \
 && echo 'rm "$debfile"' >> /usr/bin/fme-install \
 && chmod u+x /usr/bin/fme-install

ENV FME_DOWNLOAD="https://downloads.safe.com/fme/2020/fme-desktop-2020_2020.0.0.1.20202~ubuntu.18.04_amd64.deb"

WORKDIR /fme-install

CMD ["fme-install"]
