#!/bin/bash

set -e

echo "Updating package index..."
sudo apt update

echo "Installing required packages..."
sudo apt install -y ca-certificates curl

echo "Creating Docker keyrings directory..."
sudo install -m 0755 -d /etc/apt/keyrings

echo "Adding Docker official GPG key..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Adding Docker APT repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index again..."
sudo apt update

echo "Installing Docker Engine..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Docker installation completed."

echo "Testing Docker..."
sudo docker run hello-world
