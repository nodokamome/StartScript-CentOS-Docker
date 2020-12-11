#!/bin/bash
set -x;

#環境変数
ADMIN_NAME="@@@ADMIN_NAME@@@"
ADMIN_PASSWORD="@@@ADMIN_PASSWORD@@@"
SSH_PORT="@@@SSH_PORT@@@"

# アップデート
yum update -y;
localectl set-locale LANG=ja_JP.utf8;

# ユーザ設定
useradd ${ADMIN_NAME};
echo ${ADMIN_PASSWORD} | passwd --stdin ${ADMIN_NAME};
usermod -G wheel ${ADMIN_NAME};
echo "${ADMIN_NAME} ALL=NOPASSWD: ALL" | EDITOR='tee -a' visudo >/dev/null;

# 公開鍵認証
mkdir /home/${ADMIN_NAME}/.ssh
mv /root/.ssh/authorized_keys /home/${ADMIN_NAME}/.ssh/authorized_keys
chmod 700 /home/${ADMIN_NAME}/.ssh
chmod 600 /home/${ADMIN_NAME}/.ssh/authorized_keys 
chown ${ADMIN_NAME}:${ADMIN_NAME} /home/${ADMIN_NAME}/.ssh -R

#ssh設定
sed -i -e "s/#PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config;
sed -i -e "s/#Port 22/Port ${SSH_PORT}/" /etc/ssh/sshd_config;
sed -i -e "s/PasswordAuthentication yes/PasswordAuthentication no"
sudo systemctl restart sshd;

#firewalld
systemctl enable firewalld;
systemctl start firewalld;
sed -i -e "s/22/${SSH_PORT}/" /usr/lib/firewalld/services/ssh.xml;
firewall-cmd --reload;

# Docker install
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker
systemctl start docker

# Docker-Compose v1.27.4 install
curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose

sh -c "echo -e '##########\nReboot after 10 seconds\n##########' | wall -n; sleep 10; reboot" &
exit 0
