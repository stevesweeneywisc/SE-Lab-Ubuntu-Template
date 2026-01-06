#! /bin/bash

# Enable verbose execution of this script
set -v

echo ##########   start     ############
echo #####Ubuntu Base Install##########

echo ##########   start     ############
echo ###### Application Install ########
sudo apt update -y
sudo apt dist-upgrade –y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt install -y openssh-server
sudo apt install -y net-tools open-vm-tools-desktop conky-all dconf-editor
sudo apt-get install -y wget
sudo apt-get install -y curl
sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common
sudo apt install -y python3-pip 
sudo apt remove -y ufw
sudo apt-get install -y qemu-guest-agent
sudo systemctl start qemu-guest-agent
sudo systemctl enable qemu-guest-agent
echo ##########     end     ############
echo ###### Application Install ########


echo ##########   start     ############
echo #######sudo no password############
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
echo ##########     end     ############
echo #######sudo no password############

echo ##########   start    ############
echo ##########conky config############
echo # Prep and Move "conky.conf" to /etc/conky
chmod 644 conky.conf
sudo chown root conky.conf
sudo chown :root conky.conf
sudo mv conky.conf /etc/conky/

echo # Prep and Move "xeventbind" and "touch-conky-conf.sh" to /home/$USER/scripts
chmod 777 touch-conky-conf.sh
chmod 111 xeventbind
mkdir /home/$USER/scripts
mv touch-conky-conf.sh /home/$USER/scripts/
mv xeventbind          /home/$USER/scripts/

echo ## Move Startup Application config files
chmod 644 conky.desktop
chmod 644 xeventbind.desktop
mkdir ../.config/autostart
mv conky.desktop ../.config/autostart/
mv xeventbind.desktop ../.config/autostart/

echo ##########    end     ############
echo ##########conky config############

echo ##########   start    ############
echo ####### Update Cron Job ##########
echo # Prep permissions on files
chmod 600 fortinet
chmod 755 update.sh

echo # Prep owner and group on files
sudo chown fortinet fortinet
sudo chown :crontab fortinet

echo # Move files to $USER home and /var/spool/cron/crontabs/
sudo mv update.sh /home/$USER/
sudo mv fortinet /var/spool/cron/crontabs/
echo ##########   end      ############
echo ####### Update Cron Job ##########

echo ########### start ################
echo ####gnome desktop settings #######
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false
gsettings set org.gnome.shell.extensions.ding show-home false
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
cat shell.preferences | dconf load /org/gnome/shell/
echo ######### Set Wallpaper ##########
mv ./Wallpaper/* ../Pictures/
gsettings set org.gnome.desktop.background picture-uri file:////home/$USER/Pictures/Clone-Template.png
gsettings set org.gnome.desktop.background picture-uri-dark file:////home/$USER/Pictures/Clone-Template.png
gsettings set org.gnome.desktop.background picture-options 'stretched'
echo ##### terminal GNOME dark ########
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-theme-colors false
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/foreground-color "'rgb(208,207,204)'"
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-color "'rgb(23,20,33)'"
echo #### Setup RDP ####
systemctl --user start gnome-remote-desktop
systemctl --user enable gnome-remote-desktop
grdctl rdp enable
grdctl rdp set-credentials fortinet "password"
grdctl rdp disable-view-only
#echo ###########  end  ################
#echo ####gnome desktop settings #######


echo ###### start last check   ########
echo ######application install#########
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
echo ###### end last check   ##########
echo ######application install#########

echo ##########   start    ############
echo #####Ubuntu-X_Install Script######
echo # Prep permissions on file
chmod 777 Ubuntu-X_Install.sh

echo # Move files to Fortinet home directory
sudo mv Ubuntu-X_Install.sh /home/fortinet

echo ##########    end     ############
echo #####Ubuntu-X_Install Script######

echo ##########    end     ############
echo #####Ubuntu Base Install##########
rm shell.preferences
rm Ubuntu_Base_Install.tar
rm Ubuntu_Base_Install.sh
rm -r Wallpaper

echo ##########   Reboot   ############
sudo reboot now