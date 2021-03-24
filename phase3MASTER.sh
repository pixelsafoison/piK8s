#!/bin/sh

echo "Welcome to phase 3 of the kubernetes deployment script!"
echo "!!!!! This script is to be run ONLY onto the master node !!!!!"
echo " "
echo "this script will:"
echo "  1. Initialize your pod network"
echo "  2. Set up your config directory"
echo "  3. Install the flannel network driver"
echo " "
echo " "
echo "This script will start in 10 seconds, if you do not wish to run it cancel the execution using ctrl+C"
sleep 20s
clear
sleep 0.5s



## Initializing pod network
echo ">> pod network with sudo kubeadm init --pod-network-cidr=10.244.0.0/16"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

## Setting up config directory
echo ">> Setting up config directory"
mkdir -p ~.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

## Installing flannel network driver
echo ">> Installing flannel network driver"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo " "
echo "DONE! :)"