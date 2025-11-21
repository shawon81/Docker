#!/bin/bash

set -e

echo "=== Docker Full Installation Script for Kali/Debian ==="

#---------------------------------------------------------
# 1. Update system
#---------------------------------------------------------
echo "[1/7] Updating system..."
sudo apt update -y
sudo apt upgrade -y


#---------------------------------------------------------
# 2. Install required dependencies
#---------------------------------------------------------
echo "[2/7] Installing required dependencies..."

sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https \
    software-properties-common


#---------------------------------------------------------
# 3. Add Docker GPG key and repository
#---------------------------------------------------------
echo "[3/7] Adding Docker official GPG key..."

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


#---------------------------------------------------------
# 4. Install Docker Engine + CLI + Buildx + Compose
#---------------------------------------------------------
echo "[4/7] Installing Docker Engine and related tools..."

sudo apt update -y
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin


#---------------------------------------------------------
# 5. Enable and start Docker
#---------------------------------------------------------
echo "[5/7] Enabling Docker service..."

sudo systemctl enable docker
sudo systemctl start docker


#---------------------------------------------------------
# 6. Add current user to 'docker' group
#---------------------------------------------------------
echo "[6/7] Adding user to docker group..."
sudo usermod -aG docker "$USER"


#---------------------------------------------------------
# 7. OPTIONAL: Install Docker Desktop if .deb file exists
#---------------------------------------------------------
DEB_FILE="docker-desktop-amd64.deb"

if [ -f "$DEB_FILE" ]; then
    echo "[7/7] Docker Desktop .deb found. Installing..."
    sudo dpkg -i "$DEB_FILE" || sudo apt --fix-broken install -y
else
    echo "[7/7] Docker Desktop .deb not found. Skipping."
fi


#---------------------------------------------------------
# Done
#---------------------------------------------------------
echo "========================================================="
echo " Docker installation completed successfully."
echo " Log out and log back in to enable 'docker' group access."
echo "========================================================="

chmod +x Docker.sh
./Docker.sh

