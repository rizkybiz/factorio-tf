#!/bin/sh

# wait long enough for unattended  apt upgrades to finish
sleep 30s

# update packages and install a few utilities
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y --allow-downgrades --allow-remove-essential --allow-change-held-packages
sudo DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade
sudo apt-get install -y curl xz-utils

# download the headless factorio server and unpack
sudo curl -sSL "https://www.factorio.com/get-download/1.1.50/headless/linux64" -o factorio_headless.tar.xz
sudo xz -d factorio_headless.tar.xz
sudo tar -xf ./factorio_headless.tar

# move everything to opt & cleanup
sudo mv factorio /opt/factorio
sudo rm ./factorio_headless.tar
sudo mkdir /opt/factorio/config

# setup non-root user permissions
sudo adduser --disabled-login --no-create-home --gecos factorio factorio

