#!/bin/bash
#
echo "code-server start"
curl -fsSL https://code-server.dev/install.sh | sudo sh
mkdir -p ~/.config/code-server
touch ~/.config/code-server/config.yaml
cat ./config.yaml >>~/.config/code-server/config.yaml
cat ~/.config/code-server/config.yaml
sudo systemctl enable --now code-server@$USER
sudo systemctl start code-server@$USER
sudo systemctl status code-server@$USER
echo "code-server end"