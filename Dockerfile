FROM ubuntu:18.04

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get -q update \
 && apt-get -qy --no-install-recommends install wget \
 && rm -rf /var/lib/apt/lists/* \
 && echo '#!/bin/bash' > /usr/bin/fme-upgrade \
 && chmod u+x /usr/bin/fme-upgrade

ENV DOWNLOADS_DIR="/downloads"

CMD ["fme-upgrade"]
