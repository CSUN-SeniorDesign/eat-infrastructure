#!/bin/bash
set -e

echo "Setting up cronjob(s)"
sudo mkdir /home/ubuntu/cronjobs/
sudo mv cron1.sh /home/ubuntu/cronjobs/cron1.sh
sudo chmod 755 /home/ubuntu/cronjobs/cron1.sh

# echo '#!/bin/bash' >> /home/ubuntu/cronjobs/s3cron.sh
# echo 'echo "hello `date`" >> /home/ubuntu/cronjobs/'
