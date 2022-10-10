#!/bin/bash

sudo groupadd media
sudo adduser --system --no-create-home --ingroup media radarr
sudo usermod -a -G media radarr
sudo mkdir -p /var/lib/radarr
sudo chown -R radarr:media /var/lib/radarr
sudo chmod 775 /var/lib/radarr
sudo apt install curl sqlite3
wget --content-disposition "http://radarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64"
tar -xvzf Radarr*.linux*.tar.gz
sudo mv Radarr /opt
sudo chown radarr:media -R /opt/Radarr
cat << EOF | sudo tee /etc/systemd/system/radarr.service > /dev/null
[Unit]
Description=Radarr Daemon
After=syslog.target network.target
[Service]
User=radarr
Group=media
Type=simple

ExecStart=/opt/Radarr/Radarr -nobrowser -data=/var/lib/radarr/
TimeoutStopSec=20
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl -q daemon-reload
sudo systemctl enable --now -q radarr