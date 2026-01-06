#! /bin/bash

echo #########     Start      #########
echo #########  Update Ubuntu #########

sudo apt update --assume-yes
sudo apt upgrade --assume-yes
sudo apt autoremove --assume-yes

tail /home/fortinet/update.log > /home/fortinet/update.tmp
echo "Last Ran:" >> /home/fortinet/update.tmp
/usr/bin/date    >> /home/fortinet/update.tmp
rm /home/fortinet/update.log
mv /home/fortinet/update.tmp /home/fortinet/update.log

echo #########      End       #########
echo #########  Update Ubuntu #########
