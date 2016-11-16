FROM debian:sid
MAINTAINER Andrea Capriotti <capriott@gmail.com>

VOLUME /home

RUN sed -i '0,/RE/s/main/main contrib/' /etc/apt/sources.list

RUN apt-get update && apt-get upgrade -yq && apt-get install -yq --install-recommends \
    firefox flashplugin-nonfree libgl1-mesa-dri libvdpau-va-gl1 va-driver-all fonts-dejavu \
    gstreamer1.0-plugins-good gstreamer1.0-x gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-base gstreamer1.0-alsa && apt-get clean && \
    rm -rf /var/lib/apt/lists/

RUN update-flashplugin-nonfree --install

RUN groupadd -g 1000 storage && useradd -u 1000 -g storage -G audio storage

USER storage

CMD ["/usr/bin/firefox" ,"-new-instance"]
