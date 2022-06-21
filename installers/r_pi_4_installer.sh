#!/bin/bash
clear 

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Welcome to the MotionEye <-> Matrix Integration Setup"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo 
sleep 2
echo "© Copyright (c) 2022 Open Source Videos Capstone Project 2022"
echo "GitHub original Repo -> https://github.com/Open-Source-Videos/Matrix-surveillance-camera-controller"
sleep 2 
echo 
echo "Let's start with updating your system and installing"
echo "the base components for MotionEye"
sleep 2
sudo apt-get update -y
sudo apt-get install ffmpeg libmariadb3 libpq5 libmicrohttpd12 -y
wget https://github.com/Motion-Project/motion/releases/download/release-4.4.0/pi_buster_motion_4.4.0-1_armhf.deb
sudo dpkg -i pi_buster_motion_4.4.0-1_armhf.deb
sudo rm pi_buster_motion_4.4.0-1_armhf.deb

sudo systemctl stop motion
sudo systemctl disable motion

sudo apt-get install python2 python-dev-is-python2 -y
sudo curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
sudo apt-get install libssl-dev libcurl4-openssl-dev libjpeg-dev zlib1g-dev -y
sudo python2 -m pip install motioneye

sudo mkdir -p /etc/motioneye
sudo cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
sudo mkdir -p /var/lib/motioneye

sudo cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
sudo systemctl daemon-reload
sudo systemctl enable motioneye
sudo systemctl start motioneye
echo
echo "Lets take a moment of rest"
echo "before we install Python and the Matrix component \"matrix-nio\""
sleep 2
echo
echo "...and off we go 🚀"

sudo apt-get -y install python3-pip
sudo apt-get install libzbar-dev libzbar0 -y
sudo apt install libolm3 libolm-dev -y
sudo python3 -m pip install python-olm

sudo pip3 install matrix-nio
sudo pip3 install "matrix-nio[e2e]"

sudo python3 -m pip install --upgrade Pillow
sudo python3 -m pip install python-magic

sudo python3 -m pip install watchdog

echo 
echo "And we're close to finish"
echo "Let's copy the important files and setup the systemd-daemon"
sleep 2 
sudo mkdir /var/lib/ossc_client
sudo mkdir /var/lib/ossc_client/log
sudo mkdir /var/lib/ossc_client/credentials


sudo cp -v ./ossc_client.py /var/lib/ossc_client
sudo cp -v ./config.cfg /var/lib/ossc_client
sudo cp -v ./ossc_client_service.sh /var/lib/ossc_client
chmod -v +x /var/lib/ossc_client/ossc_client_service.sh

sudo cp -v ./systemd_service/osscd.service /etc/systemd/system/ 
systemctl daemon-reload
systemctl enable osscd.service 

## getting local ip 
local_ip="$(hostname -I)"

## Post Install Disclaimer
echo
echo 
echo "Completed install script"
sleep 1
echo 
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "                 IMPORTANT      "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
sleep 1
echo 
echo "To integrate MotionEye and Matrix successfully please follow these steps"
echo 
echo "1. Go to $local_ip:8765 and configure MotionEye.(at least add your Cams there)"
echo "   The standard credentials are"
echo "   username: admin"
echo "   password:       <--- leave the password field empty"
echo
echo
echo "2. Run --> python3 /var/lib/ossc_client/ossc_client.py <-- to configure your Matrix connection."
echo "   You'll need a RoomID in which the user you'll configure is member."
echo
echo
echo "3. Restart the daemon with --> systemctl start osscd"
echo 
echo "That's it, you're good to go"
echo "For more info checkout the readme and communication_ref.md"
sleep 1
echo
echo "Bye :) "
exit
