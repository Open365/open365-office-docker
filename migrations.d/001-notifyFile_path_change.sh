#!/usr/bin/env bash

# Add macro to libreoffice
# This macro is executed "on document title change" and sends through
# the bus the current file path

LO_SKEL_FOLDER="/etc/skel/.config/libreoffice"
LO_USER_CONFIG_FOLDER="/home/user/.config/libreoffice"

if [ -d "$LO_USER_CONFIG_FOLDER" ] && ! grep -qr "notifyFilePathChanged" "$LO_USER_CONFIG_FOLDER"
then
    echo "Running migration: libreOffice notifyFilePathChange"
    cp "$LO_SKEL_FOLDER"/4/user/registrymodifications.xcu "$LO_USER_CONFIG_FOLDER"/4/user/registrymodifications.xcu
    cp "$LO_SKEL_FOLDER"/4/user/basic/Standard/Module1.xba "$LO_USER_CONFIG_FOLDER"/4/user/basic/Standard/Module1.xba
    echo "Migration done"
else
    echo "libreOffice notifyFilePathChange migration: Nothing to migrate"
fi
