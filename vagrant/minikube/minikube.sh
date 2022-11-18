#!/bin/bash
sudo apt-get -y install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
thisArch=$(dpkg --print-architecture)
echo "deb [arch=$thisArch signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu stable" > /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker nico
newgrp docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl enable docker.service

## install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
#minikube start

## add autocomplete and kubectl alias in ~/.bashrc
alias kubectl="minikube kubectl --"
source <(kubectl completion bash)
source <(minikube completion bash)


## create minikube service /etc/systemd/system/minikube.service

cat << EOF > /etc/systemd/system/minikube.service
[Unit]
Description=Kickoff Minikube Cluster
After=docker.socket containerd.service docker.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/minikube start
RemainAfterExit=true
ExecStop=/usr/local/bin/minikube stop
StandardOutput=journal
User=nico
Group=nico

[Install]
WantedBy=multi-user.target
EOF

### start and enable minikube service
sudo systemctl daemon-reload
systemctl enable minikube
