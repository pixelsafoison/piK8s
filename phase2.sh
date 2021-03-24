#!/bin/sh


echo "Welcome to phase 2 of the kubernetes deployment script!"
echo " "
echo "this script will:"
echo "  1. Update your packages list"
echo "  2. Install docker and add pi to the docker usergroup"
echo "  3. create and edit your docker daemon config at /etc/docker/daemon.json"
echo "  4. Install the kubernetes repository and required key"
echo "  5. Install kubectl, kubeadm and minikube on your system"
echo "  6. Upgrade your system"
echo " "
echo " "
echo "This script will start in 20 seconds, if you do not wish to run it cancel the execution using ctrl+C"
sleep 20s
clear
sleep 0.5s

#1 updating package list
echo "-----Installing and setting up docker------"

echo ">> updating package list in the background..."
  sudo apt-get update -qq

#2. Get docker & add pi to docker group
echo ">> Getting docker & adding pi as docker user"
  curl -sSL get.docker.com | sh && \
  sudo usermod pi -aG docker


# 3 create and edit the docker daemon file
echo ">> Creating docker daemon config"
sudo touch /etc/docker/daemon.json
sudo echo ' {' >> /etc/docker/daemon.json
sudo echo '   "exec-opts": ["native.cgroupdriver=systemd"],' >> /etc/docker/daemon.json
sudo echo '   "log-driver": "json-file",' >> /etc/docker/daemon.json
sudo echo '   "log-opts": {' >> /etc/docker/daemon.json
sudo echo '     "max-size": "100m"' >> /etc/docker/daemon.json
sudo echo '   },' >> /etc/docker/daemon.json
sudo echo '   "storage-driver": "overlay2"' >> /etc/docker/daemon.json
sudo echo ' }' >> /etc/docker/daemon.json



#4. Install kubernetes repo, add key & install kubeadm, kubectl and kubelet
echo ">> Installing Kubernetes repo, kubeadm, kubectl and kubelet"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update -qq && \
  sudo apt-get install -qy -qq kubeadm && \
  sudo apt-get install -qy -qq kubectl && \
  sudo apt-get install -qy -qq kubelet
  




#7. Update all the things
echo ">> Running ap-get upgrade"
sudo apt-get upgrade -y

sleep 0.5
clear
sleep 0.5
echo "COMPLETE! Rebooting in 10 seconds"
sleep 10s

sudo reboot