#! /bin/sh

sudo yum update -y
sudo yum install -y unzip zip

# download headless factorio and unpack
sudo curl -L "https://www.factorio.com/get-download/1.1.50/headless/linux64" -o factorio_headless.tar.xz
sudo xz -d factorio_headless.tar.xz
sudo tar -xf ./factorio_headless.tar

# move everything to opt and cleanup
sudo mv factorio /opt/factorio
sudo rm ./factorio_headless.tar
sudo mkdir /opt/factorio/config

# setup non-root user permissions
sudo groupadd factorio
sudo adduser --no-create-home -g factorio factorio
sudo passwd -l factorio