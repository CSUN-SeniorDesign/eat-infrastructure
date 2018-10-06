#!/bin/bash
#!/bin/bash
#1. Make dir
sudo mkdir /var/www/staging
#2. create files

#3. move 3 new files to /etc/apache2/sites-available/
sudo mv /home/ubuntu/blog.staging.fa480.club.conf /etc/apache2/sites-available/blog.staging.fa480.club.conf
sudo mv /home/ubuntu/staging.fa480.club.conf /etc/apache2/sites-available/staging.fa480.club.conf
sudo mv /home/ubuntu/www.staging.fa480.club.conf /etc/apache2/sites-available/www.staging.fa480.club.conf

sudo git clone https://github.com/git/git
