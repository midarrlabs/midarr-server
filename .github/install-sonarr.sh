#!/bin/bash

# Install dependencies
sudo apt update
sudo apt install -y gnupg ca-certificates curl sqlite3

# Add Mono repository and key
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update
sudo apt install -y mono-devel

# Setup Sonarr user and permissions
sudo groupadd media
sudo adduser --system --no-create-home --ingroup media sonarr
sudo usermod -a -G media sonarr

# Setup directories
sudo mkdir -p /var/lib/sonarr
sudo cp ${GITHUB_WORKSPACE}/dev/sonarr/config.xml /var/lib/sonarr
sudo chown -R sonarr:media /var/lib/sonarr
sudo chmod 775 /var/lib/sonarr

# Install Sonarr
wget --content-disposition "https://download.sonarr.tv/v4/main/4.0.0.748/Sonarr.main.4.0.0.748.linux-x64.tar.gz"
tar -xvzf Sonarr*.linux*.tar.gz
sudo mv Sonarr /opt
sudo chown -R sonarr:media /opt/Sonarr

# Create and enable Sonarr service
cat << EOF | sudo tee /etc/systemd/system/sonarr.service > /dev/null
[Unit]
Description=Sonarr Daemon
After=network.target

[Service]
User=sonarr
Group=media
UMask=002
Type=simple
ExecStart=/opt/Sonarr/Sonarr -nobrowser -data=/var/lib/sonarr
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now sonarr