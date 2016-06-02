#!/usr/bin/env bash

# Add macro to libreoffice
# This macro is executed "on document title change" and sends through
# the bus the current file path

LO_SKEL_FOLDER="/etc/skel/.config/libreoffice"
LO_USER_CONFIG_FOLDER="/home/user/.config/libreoffice"

if [ -d "$LO_USER_CONFIG_FOLDER" ] && ! grep -qr "notifyFilePathChanged" "$LO_USER_CONFIG_FOLDER"
then
    rm -rf  /home/user/.config/libreoffice
    cp -r "$LO_SKEL_FOLDER" "$LO_USER_CONFIG_FOLDER"
else
    echo "libreOffice notifyFilePathChange migration: Nothing to migrate"
fi
