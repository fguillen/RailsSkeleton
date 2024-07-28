#!/bin/bash
set -e
set -x

# SSH config
read -p "SSH autohorized key: " ssh_authorized_key
echo $ssh_authorized_key >> ~/.ssh/authorized_keys

sudo apt-get update
sudo apt-get install git-core

# Install Docker
## From here: https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository

## Uninstall not official packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

## Set up Docker's apt repository.
### Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

### Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

##Install the Docker packages.
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Download the App
sudo mkdir -p /var/apps
sudo chown -R ubuntu:ubuntu /var/apps
cd /var/apps
git clone https://fguillen@github.com/fguillen/DashboardChatbot.git

# Start the App
cd /var/apps/DashboardChatbot
sudo docker-compose build
sudo docker-compose up -d
sudo docker-compose exec app bundle exec rake db:create db:schema:load
# sudo docker-compose exec app bundle exec rake db:seed # Optional
