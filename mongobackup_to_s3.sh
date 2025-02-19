#!/bin/bash
BACKUPFILE="mongodb_backup_$(date +"%Y%m%d_%H%M%S").out"
mongodump --host localhost --port 27017 --username admin --password Admin123! --authenticationDatabase admin --out /tmp/${BACKUPFILE}
aws s3 cp /tmp/${BACKUPFILE} s3://pp-wiz-demo-public-s3-bucket/${BACKUPFILE} --recursive
rm -rf /tmp/${BACKUPFILE}
