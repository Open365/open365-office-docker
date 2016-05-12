FROM    docker-registry.eyeosbcn.com/open365-base-with-dependencies

ADD     libreoffice-l10n-es_5.1.0~rc3-0ubuntu1~wily0_all.deb /root/libreoffice-l10n-es_5.1.0_all.deb
RUN     set -x ; \
        export DEBIAN_FRONTEND=noninteractive ; \
        apt-get update && apt-get install --no-install-recommends -y unzip curl && \
        cd /root && \
        curl http://artifacts.eyeosbcn.com/nexus/service/local/repositories/snapshots/content/com/eyeos/open365-office/static-files/libreoffice_pkgs.tar.gz -o libreoffice_pkgs.tar.gz && \
        mkdir debs && cd debs && \
        tar -zxvf ../libreoffice_pkgs.tar.gz && \
        dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz && \
        echo 'deb file:///root/debs /' >> /etc/apt/sources.list.d/libreoffice_pkgs.list && \
        apt-get update && \
        apt-get install --force-yes -y `cat /root/debs/Packages.gz | gzip -d | grep Package | awk '{ print $2 }'` && \
        dpkg -i /root/libreoffice-l10n-es_5.1.0_all.deb &&\
        apt-get clean && \
        apt-get autoremove -y && \
        rm -f /etc/apt/sources.list.d/libreoffice_pkgs.list && \
        rm -rf /root/debs && \
        rm /root/libreoffice_pkgs.tar.gz

RUN     export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y autoremove \
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
