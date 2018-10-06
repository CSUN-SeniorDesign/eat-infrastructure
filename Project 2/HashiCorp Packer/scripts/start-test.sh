(crontab -l 2> /dev/null; echo '*/5 * * * * /home/ubuntu/test.sh') | crontab -
