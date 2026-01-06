#! /bin/bash

### Enable verbose execution of script ###
#set -v

###### Display Help ######
Help()
{
  # Display Help
  echo
  echo "-----"
  echo "Usage"
  echo "-----"
  echo "Syntax:  Ubuntu-X_Install.sh [Ubuntu <number | name>] [production IP/mask] [default gateway IP] [OOB IP/mask]"
  echo " " 
  echo "Example 1: Ubuntu-X_Install.sh  01  10.1.1.10/24       10.1.1.1      10.100.55.71/24"
  echo "Example 2: Ubuntu-X_Install.sh  21  10.100.99.100/24   10.100.99.1   10.100.55.98/24"
  echo "Example 3: Ubuntu-X_Install.sh  IaC 172.16.3.101/24    172.16.3.1    10.100.55.101/24"
  echo " "
} 

echo ##########   Start   ############
echo ##### Identify Argument Flags ####
while getopts :h flag
do 
  case "${flag}" in
    h) # display Help
	Help
	exit;; 
    \?) # Invalid option
	echo Invalid Option !!	
	Help	
	exit;; 
  esac
done
if (($# != 4))
then
   echo "Number of arguments should be 4"
   Help
   exit
fi
echo ##########    End    ############
echo ##### Identify Arguent Flags ####

echo "Host Number        : $1";
echo "production IP/mask : $2";
echo "default gateway IP : $3";
echo "OOB IP/mask        : $4";

### Enable verbose execution of script ###
set -v

echo #########   start     ############
echo #####  Ubuntu-X Install ##########

echo ########### start ################
echo ### Create netplan yaml file #####

 echo "network:"              > Ubuntu-${1}_netplan.yaml
 echo "  version: 2"           >> Ubuntu-${1}_netplan.yaml
 echo "  ethernets:"           >> Ubuntu-${1}_netplan.yaml
 echo "    ens18:"             >> Ubuntu-${1}_netplan.yaml
 echo "      addresses:"       >> Ubuntu-${1}_netplan.yaml
 echo "        - $2"           >> Ubuntu-${1}_netplan.yaml
 echo "      routes:"          >> Ubuntu-${1}_netplan.yaml
 echo "        - to: default"  >> Ubuntu-${1}_netplan.yaml
 echo "          via: $3"      >> Ubuntu-${1}_netplan.yaml
 echo "      nameservers:"     >> Ubuntu-${1}_netplan.yaml
 echo "          addresses: [96.45.45.45, 96.45.46.46]"  >> Ubuntu-${1}_netplan.yaml
 echo "      accept-ra: false" >> Ubuntu-${1}_netplan.yaml
 echo "      link-local: []"   >> Ubuntu-${1}_netplan.yaml
 echo "    ens19:"             >> Ubuntu-${1}_netplan.yaml
 echo "      addresses:"       >> Ubuntu-${1}_netplan.yaml
 echo "        - $4"           >> Ubuntu-${1}_netplan.yaml
 echo "      accept-ra: false" >> Ubuntu-${1}_netplan.yaml
 echo "      link-local: []"   >> Ubuntu-${1}_netplan.yaml

echo ###########  End  ################
echo ### Create netplan yaml file #####

echo ########### start ################
echo # Change hostname and Wallpaper ##
gsettings set org.gnome.desktop.background picture-uri file:////home/$USER/Pictures/Fortinet-Wallpaper-${1}.png
gsettings set org.gnome.desktop.background picture-uri-dark file:////home/$USER/Pictures/Fortinet-Wallpaper-${1}.png
gsettings set org.gnome.desktop.background picture-options 'stretched'

sudo hostnamectl set-hostname ubuntu-${1}.fortinet.local
echo ###########  End  ################
echo # Change hostname and Wallpaper ##

echo ##########   start     ############
echo ###### Set IP Addresses #########
########################################
### https://documentation.ubuntu.com/server/explanation/networking/configuring-networks/
########################################
sudo chmod 600 Ubuntu-${1}_netplan.yaml
sudo chown root Ubuntu-${1}_netplan.yaml
sudo chown :root Ubuntu-${1}_netplan.yaml
sudo rm /etc/netplan/90*.yaml
sudo rm /etc/netplan/*_netplan.yaml
sudo mv Ubuntu-${1}_netplan.yaml /etc/netplan
sudo netplan apply
echo ##########   end     ############
echo ###### Set IP Addresses #########

echo ##########    end     ############
echo #####Ubuntu Base Install##########
#### rm Ubuntu-X_Install.sh
