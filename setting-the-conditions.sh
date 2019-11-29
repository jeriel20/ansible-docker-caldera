#!/usr/bin/env bash
CALDERA_BUILD_DIR='/opt/caldera'
CALDERA_VOLUME='/opt/caldera/caldera-persistent-volume'
CALDERA_SSH='/opt/caldera/ssh'

mkdir -p $CALDERA_BUILD_DIR
mkdir -p $CALDERA_VOLUME
mkdir -p $CONTEXT_SSH
ssh-keygen -q -t rsa -N '' -f $CALDERA_SSH/caldera-key
cd $CALDERA_BUILD_DIR
git clone https://github.com/jeriel20/ansible-docker-caldera.git
cd ansible-dockerfile-caldera
#
# ADD docker build or docker compose up
# run ansible playbook that configures the container caldera
# ADD open chrome browser to navigate to weg UI
