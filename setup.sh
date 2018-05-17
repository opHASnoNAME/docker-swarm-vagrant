#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt install apt-transport-https ca-certificates curl software-properties-common

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# yes we use 17.x repos
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   artful \
   stable"

sudo apt-get update
sudo apt-get install docker-ce -y
sudo usermod -aG docker vagrant
sudo service docker start
docker version
