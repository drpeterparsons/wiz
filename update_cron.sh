#!/bin/bash
crontab -l -u ubuntu > /tmp/ubuntu_cron
echo "0,10,20,30,40,50 * * * * /home/ubuntu/mongobackup_to_s3.sh" >> /tmp/ubuntu_cron
crontab -u ubuntu /tmp/ubuntu_cron
rm /tmp/ubuntu_cron
sudo systemctl start cron
sudo systemctl enable cron
