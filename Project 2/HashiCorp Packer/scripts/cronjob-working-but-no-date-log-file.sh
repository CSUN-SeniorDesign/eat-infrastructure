#!/usr/bin/env bash
set -e

echo "Setting up cronjob(s)"
mkdir /home/ubuntu/cronjobs/
touch /home/ubuntu/cronjobs/s3cron.sh
chmod 755 /home/ubuntu/cronjobs/s3cron.sh

echo "*/10 * * * * ubuntu /home/ubuntu/cronjobs/s3cron.sh" >> /home/ubuntu/cronjobs/s3cron.sh
crontab /home/ubuntu/cronjobs/s3cron.sh
