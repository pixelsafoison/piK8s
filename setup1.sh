#!/bin/sh

# Installs the base instructions up to the point of joining / creating a cluster
echo "updating package list..."
sudo apt-get update

#2. Get docker & add pi to docker group
echo "Getting docker & adding pi as docker user"
curl -sSL get.docker.com | sh && \
  sudo usermod pi -aG docker

# 2.5 edit docker daemon
echo "Creating docker daemon config"
sudo touch /etc/docker/daemon.json
sudo echo ' {' >> /etc/docker/daemon.json
sudo echo '   "exec-opts": ["native.cgroupdriver=systemd"],' >> /etc/docker/daemon.json
sudo echo '   "log-driver": "json-file",' >> /etc/docker/daemon.json
sudo echo '   "log-opts": {' >> /etc/docker/daemon.json
sudo echo '     "max-size": "100m"' >> /etc/docker/daemon.json
sudo echo '   },' >> /etc/docker/daemon.json
sudo echo '   "storage-driver": "overlay2"' >> /etc/docker/daemon.json
sudo echo ' }' >> /etc/docker/daemon.json

#3. Remove swap for good
sudo dphys-swapfile swapoff && \
  sudo dphys-swapfile uninstall && \
  sudo update-rc.d dphys-swapfile remove

#4. Install kubernetes repo, add key & install kubeadm, kubectl and kubelet
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
  sudo apt-get update -q && \
  sudo apt-get install -qy kubeadm && \
  sudo apt-get install -qy kubectl && \
  sudo apt-get install -qy kubelet
  
#5. enable ressource monitoring
echo Adding " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" to /boot/cmdline.txt

sudo cp /boot/cmdline.txt /boot/cmdline_backup.txt
orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
echo $orig | sudo tee /boot/cmdline.txt

#6. enable ipv4 forwarding
sudo cp /etc/sysctl.conf /etc/sysctl_backup.conf
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf


#7. Update all the things
sudo apt-get upgrade -y

echo " "
echo " "
echo " "
echo "Phase 1: Complete!"
echo "SYSTEM: hostname, hosts, config docker daemon, added pi to docker, removed swap, enabled ressource monitoring, enabled port forwarding, added kubernete repos."
echo "INSTALLED: kubeadm, kubectl, kubelet, system updates."
echo " "
echo "NOW REBOOTING..."
sudo reboot


#todo: edit swap