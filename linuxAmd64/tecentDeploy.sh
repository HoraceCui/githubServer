#!/bin/bash

apt update
apt install openssh-server
mkdir -p /var/run/sshd

USERNAME=root
USER_HOME="/root"
SSH_DIR="$USER_HOME/.ssh"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
chown "$USERNAME:$USERNAME" "$SSH_DIR"

# echo "🌐 下载公钥..."
curl -fsSL -o "$SSH_DIR/id_rsa.pub" https://raw.githubusercontent.com/HoraceCui/githubServer/main/eu/id_rsa.pub
echo "🌐 复制公钥..."
cp "$SSH_DIR/id_rsa.pub" "$SSH_DIR/authorized_keys"
# 设置权限
chmod 600 "$SSH_DIR/authorized_keys"
chown "$USERNAME:$USERNAME" "$SSH_DIR/authorized_keys"

# 修改sshd config..."
NEW_PORT="22"
SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak.$(date +%Y%m%d%H%M%S)"

# 备份配置
cp "$SSHD_CONFIG" "$BACKUP_FILE"
echo "📝 已备份原始配置到 $BACKUP_FILE"

# 修改 sshd_config
sed -i \
  -e "s/^#*Port .*/Port $NEW_PORT/" \
  -e "s/^#*PermitRootLogin .*/PermitRootLogin yes/" \
  -e "s/^#*PasswordAuthentication .*/PasswordAuthentication yes/" \
  -e "s/^#*PermitEmptyPasswords .*/PermitEmptyPasswords no/" \
  -e "s/^#*PubkeyAuthentication .*/PubkeyAuthentication yes/" \
  "$SSHD_CONFIG"

# 修改 ssh start
  nohup /usr/sbin/sshd > /dev/null 2>&1 & echo $! > /tmp/sshd.pid
  echo /tmp/sshd.pid

# 修改 frpc
mkdir -p ~/.ssh/frpc
tee ~/.ssh/frpc/docker-compose.yml > /dev/null <<EOF
services:
    frps:
        restart: unless-stopped
        volumes:
            - ./frpc.toml:/etc/frp/frpc.toml
        container_name: frpc-1
        image: snowdreamtech/frpc:0.54.0
        network_mode: "host" 
EOF
tee ~/.ssh/frpc/frpc.toml > /dev/null <<EOF
# frpc.toml
serverAddr = "*****"
serverPort = 31420

# auth token
auth.token = "oi*******Um"

[[proxies]]
name = "tecent"
type = "tcp"
localIP = "127.0.0.1"
localPort = 22
remotePort = 31421

EOF