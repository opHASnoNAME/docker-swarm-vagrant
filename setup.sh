#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt install apt-transport-https ca-certificates curl software-properties-common avahi-daemon -y

# install glusterfs
sudo add-apt-repository ppa:gluster/glusterfs-4.0
sudo apt-get update
sudo apt-get install glusterfs-server -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# yes we use 17.x repos
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   artful \
   stable"

sudo apt-get update && apt-get install docker-ce -y

# add vagrant user to docker group
sudo usermod -aG docker vagrant
sudo service docker start
docker version

sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

 