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
        apt-get install --force-yes -y libreoffice libreoffice-gtk3 libreoffice-style-breeze \
            libreoffice-l10n-es libreoffice-l10n-it myspell-es myspell-it && \
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
            rm -rf /car/lib/apt/lists/* \
            && \
        mkdir -p /usr/lib/open365

COPY    scripts/* /usr/bin/
COPY    libreoffice /etc/skel/.config/libreoffice

# Install theme
COPY    Breeze-gtk.zip /root/
RUN     mkdir -p /usr/share/themes && cd /usr/share/themes && unzip /root/Breeze-gtk.zip && mv theme/Breeze-gtk ./ && rm -rf theme
COPY    gtk3Settings.ini /etc/gtk-3.0/settings.ini
COPY    disable-file-locking.xcd /usr/lib/libreoffice/share/registry/disable-file-locking.xcd
COPY    run.debug.sh /root/run.debug.sh
COPY    migrations.d /usr/lib/open365/migrations.d

RUN     cd /usr/share/themes/Breeze-gtk && find . -type f -exec sed -i -e s/eff0f1/f5f6f9/g {} \;
