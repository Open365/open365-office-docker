#!/bin/bash

set -u -x

EYEOS_UNIX_USER=${EYEOS_UNIX_USER:-"user"}

SPICE_RES=${SPICE_RES:-"1280x960"}
SPICE_RES_FORMATED=`echo $SPICE_RES | tr x ' '`
SPICE_LOCAL=${SPICE_LOCAL:-"es_ES.UTF-8"}
TIMEZONE=${TIMEZONE:-"Europe/Madrid"}
SPICE_USER=${SPICE_USER:-$EYEOS_UNIX_USER}
SPICE_UID=${SPICE_UID:-"1000"}
SPICE_GID=${SPICE_GID:-"1000"}
SPICE_PASSWD=${SPICE_PASSWD:-"password"}
SPICE_KB=`echo "$SPICE_LOCAL" | awk -F"_" '{print $1}'` 
SUDO=${SUDO:-"NO"}
# USE_BIND_MOUNT_FOR_LIBRARIES: envar that handles how to make accessible
# the seafile libraries in the user space.
# * If not set, we mount the seafile dav volume directly inside the home of the
#   user.
# * If set, we mount the dav volume somewhere in /mnt and bind-mount each
#   library inside the user's home, and remove permissions in the user's home
USE_BIND_MOUNT_FOR_LIBRARIES="${USE_BIND_MOUNT_FOR_LIBRARIES:-}"
if [ "$USE_BIND_MOUNT_FOR_LIBRARIES" = "false" ]
then
	USE_BIND_MOUNT_FOR_LIBRARIES=""
fi


locale-gen $SPICE_LOCAL
echo $TIMEZONE > /etc/timezone
useradd -ms /bin/bash -u $SPICE_UID $SPICE_USER
echo "$SPICE_USER:$SPICE_PASSWD" | chpasswd
sed -i "s|#Option \"SpicePassword\" \"\"|Option \"SpicePassword\" \"$SPICE_PASSWD\"|" /etc/X11/spiceqxl.xorg.conf
unset SPICE_PASSWD
update-locale LANG=$SPICE_LOCAL
sed -i "s/XKBLAYOUT=.*/XKBLAYOUT=\"$SPICE_KB\"/" /etc/default/keyboard
sed -i "s/SPICE_KB/$SPICE_KB/" /etc/xdg/autostart/keyboard.desktop
sed -i "s/SPICE_RES/$SPICE_RES/" /etc/xdg/autostart/resolution.desktop
if [ "$SUDO" != "NO" ]; then
	sed -i "s/^\(sudo:.*\)/\1$SPICE_USER/" /etc/group
fi

cd /home/$SPICE_USER

# These should only be copied the first time
if [[ ! -f /home/$SPICE_USER/.eyeosConfigured ]]; then
	cp /root/.gtkrc-2.0 .
	cp /etc/skel/.config/ratpoisonrc .ratpoisonrc
	mkdir .config
	cp /etc/skel/.config/* .config/
	mkdir .local
	cp -r /etc/skel/.local/* .local/

	# create other files that will be needed later for some applications,
	# because we are removing write permissions in /home/$SPICE_USER later
	# and if the directories do not exist and cannot be created by the user
	# those applications that need'em may not start correctly
	mkdir -p .cache .dbus .kde

	chown $SPICE_USER /home/$SPICE_USER -R
	chown $SPICE_USER /mnt/eyeos -R

	mkdir -p /home/$SPICE_USER/.kde/share/config
	mkdir -p /home/$SPICE_USER/.kde/share/apps/
	cp -rf /etc/skel/.config/* /home/$SPICE_USER/.kde/share/config/
	cp -rf /etc/skel/.local/share/* /home/$SPICE_USER/.kde/share/apps/
	chown $SPICE_USER /home/$SPICE_USER/.kde -R

	touch /home/$SPICE_USER/.eyeosConfigured
fi

#su $SPICE_USER -c "/usr/bin/Xorg -config /etc/X11/spiceqxl.xorg.conf -logfile  /home/$SPICE_USER/.Xorg.2.log :2 &" 2>/dev/null
LANG=${LANG:-en_US.UTF-8}

/usr/sbin/locale-gen $LANG

rm /tmp/.X2-lock | true
su $SPICE_USER -c "Xspice --jpeg-wan-compression=always --vdagent :2 &"

export DISPLAY=":2"
until xset -q
do
	echo "Waiting for X server to start..."
	sleep 0.1;
done

#set custom resolution
CMD="setcustomresolution $SPICE_RES_FORMATED 59.90"
${CMD}

# Start CUPS service
service cups restart

xsetroot -solid rgb:F5/F6/F9 -cursor_name left_ptr

su $SPICE_USER -c "DISPLAY=:2 ratpoison &"
su $SPICE_USER -c "DISPLAY=:2 setxkbmap -model pc105 -layout es || true"

WORKING_DIRECTORY="/home/user"
ENVARS="HOME=/home/user"
ENVARS="$ENVARS KDE_HOME_READONLY=true"
export $ENVARS
cd "$WORKING_DIRECTORY" && sudo -E -u "$SPICE_USER" DISPLAY=:2 "$@"
