#!/bin/bash
#
# Manages auto-updating system packages using pacman
#

set -e

LOG_DEST="/var/log/arch-ansible/pacman"
LOCK_FILE_DEST="/var/log/arch-ansible/pacman_lock"
YAY_USER="ansible"

DATE=$(date -I)

mkdir -p $LOG_DEST

mklock () {
	touch $LOCK_FILE_DEST
	echo $DATE > $LOCK_FILE_DEST
}

pacman_update () {
	LOGFILE="${LOG_DEST}/${DATE}_pacman.log"

	if [ -e "$LOCK_FILE_DEST" ]; then
		echo "lock file still exists at $LOCK_FILE_DEST. Please read the logfile and then delete the lock file"
		exit 1;
	fi

	touch $LOGFILE

	echo "pacman-Syu --noconfirm" >> $LOGFILE
	pacman -Syu --noconfirm >> $LOGFILE 2>&1
	# echo "\nyay" >> $LOGFILE
	# yay &2>1 >> $LOGFILE

}

pacman_update
mklock

