#/bin/bash
# Ubuntu 18.04 LTS Server
# Install Ansible and Docker with Dependencies
apt update -qq && apt upgrade -qq
apt install -y software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible
# Install Docker and Dependencies
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common python-pip
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -qq
apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker $USER
systemctl enable docker
# Install Docker-Compose
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compo$
chmod +x /usr/local/bin/docker-compose
