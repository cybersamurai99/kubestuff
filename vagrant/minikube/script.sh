#!/bin/bash

#apt-get update
#apt-get install -y apt-transport-https ca-certificates curl software-properties-common
# add nico user
adduser nico --gecos "Nico Kruger,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "nico:nico@123" | sudo chpasswd
# add nico pub key
mkdir -p /home/nico/.ssh
echo "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEED62Zh6X7y60Wjbs0ZUaC0ydIh2Q7VUI1SBzQhz1YcgB2NTxkYkhhfVdgG6bcBE4sft7PlGim2hvYtlRj95zY= linic@cyberx" >> /home/nico/.ssh/authorized_keys
chmod -R go= /home/nico/.ssh
chown -R nico:nico /home/nico/.ssh
echo 'nico ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/admins

# install mdns
#hostnamectl set-hostname ubuntu
apt install avahi-daemon -y
systemctl start avahi-daemon
systemctl enable avahi-daemon