#!/bin/sh
#
# Incremental daily backups

RSYNC="/usr/bin/sudo /usr/bin/rsync"
TODAY=`date +"%Y%m%d"`
YESTERDAY=`date -d "1 day ago" +"%Y%m%d"`

# Set how many days of backup you want to keep, 3 is default.
OLDBACKUP=`date -d "3 days ago" +"%Y%m%d"`

SHAREUSR="/space/backups/jira-install"

# EXCLUDES="$SHAREUSR/servername.excludes"
EXCLUDES1="$SHAREUSR/$TODAY/logs"

LOG="/space/backups/logs/BACKUP_success-$TODAY.log"

SOURCE="/space/opt/jira"
DESTINATION="$SHAREUSR/$TODAY"

# Keep database backups in a separate directory.
mkdir -p $SHAREUSR/$TODAY

# SSH
# rsync -avx -e 'ssh -p22' \
 rsync -avx -e \
 --rsync-path="$RSYNC" \
 --exclude 'jira/logs/*' \
 --numeric-ids \
 --delete -r \
 --link-dest=../$YESTERDAY $SOURCE $DESTINATION

# --exclude-from=$EXCLUDES1 \


# MySQL
# ssh -p22 root@en0ch.se "mysqldump \
# --user=root \
# --password=SUPER-SECRET-PASSWORD \
# --all-databases \
# --lock-tables \
# | bzip2" > $SHAREUSR/db/$TODAY.sql.bz2

# Un-hash this if you want to remove old backups (older than 3 days)
# rm $SHAREUSR/db/$OLDBACKUP.sql.bz2
rm -R $SHAREUSR/$OLDBACKUP

# Writes a log of successful updates
echo -e "\nBACKUP success-$TODAY" >> $LOG
