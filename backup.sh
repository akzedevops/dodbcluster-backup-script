#!/bin/bash

# Set the path
export PATH=/bin:/usr/bin:/usr/local/bin

# Get the current date and time
TODAY=$(date +"%H:%M_%b%d%Y")

# Update below values
db_backup_path='/home/where-u-want-to-store'  # Make sure the path is correct and starts with a lowercase '/'

mysql_host='localhost'
mysql_port='3306'
mysql_user='your_username'
mysql_password='your_password'
database_name='your_database'
backup_retain_days=30

# Create the backup directory
backup_dir="${db_backup_path}/${TODAY}"
mkdir -p "${backup_dir}"
echo "Backup started for database - ${database_name}"

# Dump the database and compress the output
backup_file="${backup_dir}/${database_name}-${TODAY}.sql.gz"
mysqldump -h"${mysql_host}" -P"${mysql_port}" -u"${mysql_user}" -p"${mysql_password}" "${database_name}" | gzip > "${backup_file}"

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi

# Remove backups older than {backup_retain_days} days
find "${db_backup_path}" -type d -mtime +"${backup_retain_days}" -exec rm -rf {} \;

### End of script ###
