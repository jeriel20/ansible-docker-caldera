# License: GPL-3.0
# ZeroSub
FROM ubuntu AS stage1
LABEL maintainer="jj@cybercoachservices.org"

# Environment Variables for the dockerfile [passed at build time]
ENV userName="caldera"
ENV userHomeDir="/home/caldera"
ENV sshKeyDir="/home/caldera/.ssh"
ENV persistentVolume="/opt/caldera/caldera-persistent-volume"
ENV contextDirectory="/opt/caldera/ansible-dockerfile-caldera"
ENV src_SSH_PUBLIC_KEY='/opt/caldera/ssh/caldera-key'
ENV dst_SSH_public_KEY='/home/caldera/.ssh/caldera-key.pub'


WORKDIR /
USER root
RUN ln -sf /bin/bash /bin/sh

# Update system and install dependencies (gets executing during the building of the image)
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apt-utils \
    curl \
    gawk \
    gcc \
    git \
    make \
    openssh-client \
    openssh-server \
    openssl \
    rsync \
    sshpass \
    sudo \
    wget \
    sudo \
    nano \
    git \
    python3-pip \
    python3-setuptools \
    && \
    apt-get clean

# Install Upgrades
RUN apt-get -y upgrade && \
  pip install pip --upgrade

# Create New User
RUN useradd -rm -d ${userHomeDir} -s /bin/bash -g root -G sudo -u 1000 ${userName}

VOLUME ${persistentVolume}

RUN mkdir -p /opt /tmp && \
  chown -R ${userName}:${userName} /opt /tmp

USER ${userName}

RUN mkdir -p ${sshKeyDir}

USER root

# ADD SSH Public key  to the container user for Ansible to use
COPY ${src_SSH_PUBLIC_KEY} ${dst_SSH_public_KEY}

RUN chmod 755 ${sshKeyDir} && \
  chmod 644 ${dst_SSH_public_KEY} && \
  chown -R ${userName}:${userName} ${sshKeyDir}

WORKDIR ${contextDirectory}

RUN git clone --branch 2.3.2 https://github.com/mitre/caldera.git --recursive && \
  cd caldera && \
  pip install wheel && \
  pip install -r requirements.txt

# Expose Ports to host system
EXPOSE 443/tcp
EXPOSE 80/tcp
EXPOSE 8888/tcp
EXPOSE 22/tcp

CMD ["python3", "server.py"]
