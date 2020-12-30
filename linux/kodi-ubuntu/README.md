
# Kodi Ubuntu

This script for install Kodi with ubuntu server without GUI.

#### Installation of Kodi into Ubuntu Server:

#### Tested in:
  - [x] 18.04
  - [x] 20.04

The following instructions are based on the last version of Ubuntu.

#### What you need to do:

1. Download kodu-ubuntu folder https://github.com/aurelson101/scriptinstall/tree/main/linux/kodi-ubuntu
2. Run the installation script in the folder `sudo sh ./install.sh`
3. Reboot

**If you use Nvidia Graphic Card :**
-   If you agree with the recommendation feel free to use the `ubuntu-drivers` command again to install all recommended drivers:
    
`sudo ubuntu-drivers autoinstall`
    
Alternatively, install desired driver selectively using the `apt` command. For example:
    
`sudo apt install nvidia-driver-445`
    
-   Once the installation is concluded, reboot your system and you are done.

`sudo reboot`

If you have problem with nouveau :
In the terminal execute the below commands to blacklist the nouveau driver:

`sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf" `

`sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"`

Step 2: Verify the entry from blacklist-nvidia-nouveau.conf  

`cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf`

`blacklist nouveau`
`options nouveau modeset=0`

Step 3: Reboot the system  

`sudo reboot`