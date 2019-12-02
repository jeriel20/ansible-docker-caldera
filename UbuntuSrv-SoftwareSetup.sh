#/bin/bash
# Ubuntu 18.04 LTS Server
# RUN AS ROOT or with SUDO priviledges

# Variables for the this script
CALDERA_BUILD_DIR='/opt/caldera'
CALDERA_VOLUME='/opt/caldera/caldera-persistent-volume'
CALDERA_SSH='/opt/caldera/ssh'

# Install Ansible
apt update -qq && apt upgrade -qq
apt install -y software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible

# Install Docker and GIT
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common python-pip
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -qq
apt-get install -y docker-ce docker-ce-cli containerd.io git
usermod -aG docker $USER
systemctl enable docker

# Install Docker-Compose
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create folder for the docker container files and persistent volume
mkdir -p $CALDERA_BUILD_DIR
mkdir -p $CALDERA_VOLUME

# Create a folder; generate ssh key pair to add to caldera container to
# manage using ansible and other ssh avenues
mkdir -p $CONTEXT_SSH
ssh-keygen -q -t rsa -N '' -f $CALDERA_SSH/caldera-key
chown -R $USER:$USER $CALDERA_BUILD_DIR

# Download github repository in order to build the caldera container
cd $CALDERA_BUILD_DIR
git clone https://github.com/jeriel20/ansible-docker-caldera.git
cd ansible-docker-caldera
