#!/bin/sh
sleep 0.1s
clear

echo "Welcome to phase 1 of the kubernetes deployment script!"
echo " "
echo "this script will:"
echo "  1. Let you choose the name of your kubernetes node"
echo "  2. Edit both your host and hostname file to reflect your choice of name"
echo "  3. Enable ipv4 port forwarding by editing the /etc/sysctl.conf"
echo "  4. Set the size of your swap file to 0Mb by editing /etc/dphys-swapfile"
echo "  5. Enable ressource monitoring by editing the /boot/cmdline.txt file (and create a backup copy)"
echo "  6. Reboot for the changes to take effect"
echo " "
echo " Once reconnected after the reboot, execute phase2.sh to continue with the install"
echo " "
echo " "
echo "This script will start in 20 seconds, if you do not wish to run it cancel the execution using ctrl+C"
sleep 2s
clear
sleep 0.5s



## 1. Asking for hostname
echo "-----Setting up the kubernetes node name-----"
echo " "
echo "What should this kubernetes node be called? "
read NODENAME

if [ -z "$NODENAME" ]
then
  sleep 0.1s
  clear
  sleep 0.1s
  echo "-----ERROR: INVALID NODE NAME-----"
  echo "You cannot set the node name to absolutely nothing - cancelling script in 3 seconds"
  sleep 3s
  exit 1
fi
sleep 0.1s
clear
sleep 0.1s
echo "-----Setting up the kubernetes node name-----"
echo " "
echo "Okay, I will use the node name $NODENAME then ;)"
sleep 2s
clear
sleep 0.1s



#3. enable ipv4 forwarding
echo ">> Enabling ipv4 forwarding in /etc/sysctl.conf"
sudo cp /etc/sysctl.conf /etc/sysctl_backup.conf 
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

#4. Set swap file to 0Mb
echo ">> Setting swap size to 0 (assuming the default 100) in /etc/dphys-swapfile"
sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=0/g' /etc/dphys-swapfile

#5. enable ressource monitoring
echo ">> Enabling ressource monitoring"
echo Adding " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" to /boot/cmdline.txt

sudo cp /boot/cmdline.txt /boot/cmdline_backup.txt
orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
echo $orig | sudo tee /boot/cmdline.txt

## 2. Modifiying /etc/hostname and /etc/hosts
echo ">> Setting up hosts and hostname files to $NODENAME ..."
sudo sed -i "s/raspberrypi/$NODENAME/g" /etc/hostname
sudo sed -i "s/raspberrypi/$NODENAME/g" /etc/hosts
sleep 0.5s
echo ">> Done - host and hostname have both been set to $NODENAME."

echo " "
echo " "
echo " "
echo ">> ¨Phase 1 complete, rebooting..."
sleep 3s
sudo reboot

