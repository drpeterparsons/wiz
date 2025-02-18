#!/bin/bash
aws configure
BACKUPFILE="mongodb_backup_$(date +"%Y%m%d_%H%M%S").out"
mongodump --out /tmp/${BACKUPFILE}
aws s3 cp /tmp/${BACKUPFILE} s3://pp-wiz-demo-public-s3-bucket/${BACKUPFILE} --recursive
rm -rf /tmp/${BACKUPFILE}
