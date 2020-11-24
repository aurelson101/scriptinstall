# Duplicity Backup
Duplicity designs a scheme where the first archive is a full backup, and subsequent (incremental) backups only add differences from the last full or incremental backup. Chains consisting of a full backup and a series of incremental backups can be recovered at the time any of the incremental steps have been performed. If one of the incremental backups is missing, subsequent incremental backups cannot be rebuilt.

Dupliciti uses the SFTP and FTP (S) protocols so it can run a local GNU / Linux machine or a VPS server to a VPS server.


# Files

Please edit backup.sh and change for your configuration

# To run a full backup
```bash
backup.sh full
```
Files or directories not to be backed up are passed to Duplicity by --exclude.
The script can be run through a daily cron job :
**/etc/cron.weekly** (weekly) or 
**/etc/cron.monthly** (monthly). 

A crontab can also be used to schedule an exact time by configuring a file under /etc/cron.d/ :
```bash
0 0 * * * /root/backup.sh >/dev/null 2>&1
```
