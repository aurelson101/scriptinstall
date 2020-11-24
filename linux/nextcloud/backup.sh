#!/bin/bash
#
# Simple script for creating backups with Duplicity.
# Full backups are made on the 1st day of each month or with the 'full' option.
# Incremental backups are made on any other days.
#
# USAGE: backup.sh [full]
#

# get day of the month
DATE=`date +%d`

# Set protocol (use SFTP or FTP, see manpage for more)
PROTO=sftp

# set user and hostname of backup account
USER='cdXXXXX'
HOST='rs1.cloudlws.com'

# Setting the password for the Backup account that the
# backup files will be transferred to.
# for sftp a public key can be used, see:
PASSWORD='password'

# directories to backup
DIRS="/var/www/monsiteweb.fr/web /home" 
TDIR="files/"$(hostname -s)

# Setting the pass phrase to encrypt the backup files. Will use symmetrical keys in this case.
PASSPHRASE='yoursecretgpgpassphrase'
export PASSPHRASE

##############################

if [ $PASSWORD ]; then
 BAC="$PROTO://$USER:$PASSWORD@$HOST"
else
 BAC="$PROTO://$USER@$HOST"
fi

# Check to see if we're at the first of the month.
# If we are on the 1st day of the month, then run
# a full backup. If not, then run an incremental
# backup.

if [ $DATE = 01 ] || [ "$1" = 'full' ]; then
 TYPE='full'
else
 TYPE='incremental'
fi

for DIR in $DIRS
do
  # first remove everything older than 2 months
  duplicity remove-older-than 2M -v5 --force $BAC/$TDIR/$DIR
  # do a backup
  duplicity $TYPE -v5 $DIR $BAC/$TDIR/$DIR
done

# Check the manpage for all available options for Duplicity.
# Unsetting the confidential variables
unset PASSPHRASE
unset PASSWORD

exit 0