#! /bin/sh

# download and unpack factorio
sudo curl -Ls "https://www.factorio.com/get-download/'"$FACTORIO_VERISON"'/headless/linux64" -o factorio_headless.tar.xz
sudo xz -d factorio_headless.tar.xz
sudo tar -xf factorio_headless.tar
sudo rm factorio_headless.tar

# move factorio binary to proper location
sudo mv factorio /opt/factorio

# set up directory
sudo mkdir /opt/factorio/config

# create non root user and group
sudo groupadd factorio
sudo adduser --no-create-home -g factorio factorio
sudo passwd -l factorio
