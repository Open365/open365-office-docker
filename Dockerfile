FROM    docker-registry.eyeosbcn.com/open365-base-with-dependencies

RUN     set -x ; \
        export DEBIAN_FRONTEND=noninteractive ; \
        apt-get update && apt-get install --no-install-recommends -y unzip && \
        apt-get update && \
        apt-get install -y libreoffice libreoffice-gtk3 libreoffice-style-breeze libreoffice-l10n-es libreoffice-l10n-it && \
        apt-get clean && \
        apt-get autoremove -y

RUN     export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y autoremove \
            g++ \
            gcc \
            netcat \
            netcat-openbsd \
            netcat-traditional \
            ngrep \
            strace \
            wget \
            && \
            apt-get clean && \
            rm -rf /car/lib/apt/lists/*

COPY    scripts/* /usr/bin/
COPY    libreoffice /etc/.skel/.config/libreoffice

# Install theme
COPY    Breeze-gtk.zip /root/
RUN     mkdir -p /usr/share/themes && cd /usr/share/themes && unzip /root/Breeze-gtk.zip && mv theme/Breeze-gtk ./ && rm -rf theme
COPY    gtk3Settings.ini /etc/gtk-3.0/settings.ini
COPY    disable-file-locking.xcd /usr/lib/libreoffice/share/registry/disable-file-locking.xcd
COPY    run.debug.sh /root/run.debug.sh
