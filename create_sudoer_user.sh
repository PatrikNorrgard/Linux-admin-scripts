#! /bin/bash

# Script that creates users with only ssh key  authentication, and allows them to run sudo without setting a password.
# Requiers SUDO, tested on Centos (Red had flavour) and Ubuntu (Debian flavour).
# License MIT
# Author Patrik Norrgård <pnorrgard@hotmail.com>

if [ $# -eq 0 ]
  then
    echo "Provide username to be created. Please have the users public key ready, and paste it into nano. Save the key with CTRL+X and answer yes, if prompted."
    echo "Requires sudo persmission to run."
    exit 0
fi

if [ "$EUID" -ne 0 ]
  then echo "Please run with SUDO as we need root privileges to create users"
  exit 1
fi

useradd -m -d /home/$1 -s /bin/bash $1
mkdir /home/$1/.ssh
chown -R $1:$1 /home/$1/.ssh
chmod 700 /home/$1/.ssh
nano /home/$1/.ssh/authorized_keys
chmod 600 /home/$1/.ssh/authorized_keys
chown -R $1:$1 /home/$1
echo $1 ' ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers.d/users
