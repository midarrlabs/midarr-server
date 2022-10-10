#!/bin/bash

sudo groupadd media
sudo adduser --system --no-create-home --ingroup media sonarr
sudo usermod -a -G media sonarr
sudo mkdir -p /var/lib/sonarr
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

ExecStart=/opt/Sonarr/Sonarr.exe -nobrowser -data=/var/lib/sonarr/
TimeoutStopSec=20
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl -q daemon-reload
sudo systemctl enable --now -q sonarr
sudo journalctl --since today -u sonarr