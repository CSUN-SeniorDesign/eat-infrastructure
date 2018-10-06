#!/bin/bash

### 1. 1 run a2dissite <text file name, e.g. staging.fa480.club>
### 2. repeat #1 for all 3 (staging, www.staging and blog.staging)
sudo /etc/init.d/apache2 reload

#sudo a2dissite www.staging.fa480.club
#sudo a2dissite staging.fa480.club
#sudo a2dissite blog.staging.fa480.club
# 3. then edit those 3 text files in sites-available and change documentRoot to /var/www/staging
# 4. then run /etc/init.d/apache2 reload
sudo /etc/init.d/apache2 reload
# 5. then run a2-ensite for all 3 text files in sites-availble
#    e.g. a2ensite staging.fa480.club
sudo a2ensite www.staging.fa480.club.conf
sudo a2ensite staging.fa480.club.conf
sudo a2ensite blog.staging.fa480.club.conf
# 7. then run /etc/init.d/apache2 reload again
sudo /etc/init.d/apache2 reload
