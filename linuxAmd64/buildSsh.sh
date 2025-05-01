#!/bin/bash
#
echo "build ssh start"
mkdir ~/.ssh
touch ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
cat ./id_rsa.pub >> ~/.ssh/authorized_keys
sudo systemctl restart sshd.service
echo "build ssh end"