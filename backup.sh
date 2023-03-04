#!/bin/bash

# Set the path
export PATH=/bin:/usr/bin:/usr/local/bin

# Get the current date and time
TODAY=$(date +"%H:%M_%b%d%Y")

################################################################
################## Update below values  ########################

# Set the database backup path
db_backup_path='/Home/where-u-want-to-store'

# Set the MySQL connection details
mysql_host=''
mysql_port=''
mysql_user=''
mysql_password=''

# Set the database name
database_name=''

# Set the number of days to retain the backups
backup_retain_days=30

#################################################################

# Create the backup directory
mkdir -p "${db_backup_path}/${TODAY}"
echo "Backup started for database - ${database_name}"

# Dump the database and compress the output
mysqldump -h "${mysql_host}" \
          -P "${mysql_port}" \
          -u "${mysql_user}" \
          -p"${mysql_password}" \
          "${database_name}" --set-gtid-purged=OFF | gzip > "${db_backup_path}/${TODAY}/${database_name}-${TODAY}.sql.gz"

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi

# Remove backups older than {backup_retain_days} days
db_del_date=$(date +"%d%b%Y" --date="${backup_retain_days} days ago")

if [ ! -z "${db_backup_path}" ]; then
    cd "${db_backup_path}"
    if [ ! -z "${db_del_date}" ] && [ -d "${db_del_date}" ]; then
        echo "Deleting backup directory: ${db_del_date}"
        rm -rf "${db_del_date}"
    else
        echo "No backup directory found to delete for date: ${db_del_date}"
    fi
fi

#--set-gtid-purged=OFF is for cluster dumping 
### End of script ###
