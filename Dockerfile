FROM    docker-registry.eyeosbcn.com/open365-base-with-dependencies

RUN     set -x ; \
        export DEBIAN_FRONTEND=noninteractive ; \
        apt-get update && apt-get install --no-install-recommends -y unzip curl && \
        cd /root && \
        curl "https://s3-eu-west-1.amazonaws.com/open365-aptmirror/libreoffice_pkgs.tar.gz" -o libreoffice_pkgs.tar.gz && \
        mkdir debs && cd debs && \
        tar -zxvf ../libreoffice_pkgs.tar.gz && \
        dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz && \
        echo 'deb file:///root/debs /' >> /etc/apt/sources.list.d/libreoffice_pkgs.list && \
        apt-get update && \
        apt-get install --force-yes -y `cat /root/debs/Packages.gz | gzip -d | grep Package | awk '{ print $2 }'` && \
        apt-get install --force-yes -y libreoffice-l10n-es libreoffice-l10n-it && \
        apt-get clean && \
        rm -f /etc/apt/sources.list.d/libreoffice_pkgs.list && \
        rm -rf /root/debs && \
        rm /root/libreoffice_pkgs.tar.gz &&\
        apt-get update && apt-get -y autoremove \
            curl \
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
