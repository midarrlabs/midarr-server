#!/bin/bash

sudo apt install gnupg ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update
sudo apt install mono-devel

sudo groupadd media
sudo adduser --system --no-create-home --ingroup media sonarr
sudo usermod -a -G media sonarr

sudo chown -R sonarr:media /library/series
sudo chmod 775 /library/series

sudo mkdir -p /var/lib/sonarr
sudo mv ${GITHUB_WORKSPACE}/priv/sonarr/config.xml /var/lib/sonarr
sudo chown -R sonarr:media /var/lib/sonarr
sudo chmod 775 /var/lib/sonarr

sudo apt install curl sqlite3
wget --content-disposition "https://download.sonarr.tv/v3/main/3.0.9.1549/Sonarr.main.3.0.9.1549.linux.tar.gz"
tar -xvzf Sonarr*.linux*.tar.gz
sudo mv Sonarr /opt
sudo chown sonarr:media -R /opt/Sonarr
cat << EOF | sudo tee /etc/systemd/system/sonarr.service > /dev/null
[Unit]
Description=Sonarr Daemon
After=syslog.target network.target
[Service]
User=sonarr
Group=media
Type=simple

ExecStart=/usr/bin/mono --debug /opt/Sonarr/Sonarr.exe -nobrowser -data=/var/lib/sonarr
TimeoutStopSec=20
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl -q daemon-reload
sudo systemctl enable --now -q sonarr
sudo journalctl --since today -u sonarr