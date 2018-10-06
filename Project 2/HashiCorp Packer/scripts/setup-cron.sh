#!/bin/bash
sudo chmod 755 /home/ubuntu/cron1.sh
sudo chmod 755 /home/ubuntu/cron2.sh
sudo chmod 755 /home/ubuntu/S3-Fetch.py

sudo mkdir /home/ubuntu/fetch-staging
sudo mkdir /home/ubuntu/fetch-production

sudo cp /home/ubuntu/S3-Fetch.py /home/ubuntu/fetch-staging/S3-Fetch.py
sudo mv /home/ubuntu/S3-Fetch.py /home/ubuntu/fetch-production/S3-Fetch.py
