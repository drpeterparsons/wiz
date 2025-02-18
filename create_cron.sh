#!/bin/bash
sudo crontab -l -u root > /tmp/ubuntu_cron
sudo echo "0,10,20,30,40,50 * * * * /home/ubuntu/mongobackup_to_s3.sh" >> /tmp/ubuntu_cron
sudo crontab -u root /tmp/ubuntu_cron
sudo rm /tmp/ubuntu_cron
sudo systemctl start cron
sudo systemctl enable cron
