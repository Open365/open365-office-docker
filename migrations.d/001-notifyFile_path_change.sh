#!/usr/bin/env bash

# Add macro to libreoffice
# This macro is executed "on document title change" and sends through
# the bus the current file path

LO_SKEL_FOLDER="/etc/skel/.config/libreoffice"
USER_CONFIG_FOLDER="/home/user/.config"
LO_USER_CONFIG_FOLDER="$USER_CONFIG_FOLDER/libreoffice"

if [ ! -f "$USER_CONFIG_FOLDER"/open365_LO_migrated_3_Jun_2016 ]
then
    touch "$USER_CONFIG_FOLDER"/open365_LO_migrated_3_Jun_2016
    rm -rf  "$LO_USER_CONFIG_FOLDER"
    cp -r "$LO_SKEL_FOLDER" "$LO_USER_CONFIG_FOLDER"
else
    echo "libreOffice notifyFilePathChange migration: Nothing to migrate"
fi
