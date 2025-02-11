#!/bin/bash
BACKUPFILE="mongodb_backup_$(date +"%Y%m%d_%H%M%S").out"
mongodump --out /tmp/${BACKUPFILE}
aws s3 cp /tmp/{BACKUPFILE} s3://ppwizdemo/{BACKUPFILE} --recursive
rm -rf /tmp/${BACKUPFILE}
