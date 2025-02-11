sudo crontab -l -u root > /tmp/root_cron
echo "0,10,20,30,40,50 * * * * /home/ubuntu/mongobackup_to_s3.sh" >> /tmp/root_cron
sudo crontab -u root /tmp/root_cron
rm /tmp/root_cron
