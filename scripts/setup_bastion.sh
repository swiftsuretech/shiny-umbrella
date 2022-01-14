#!/bin/bash

# Install docker
echo Installing Docker and other packages
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum -y install epel-release
sudo yum -y install docker-ce docker-ce-cli containerd.io python3 python3-pip epel-release ansible
sudo systemctl start docker
sudo usermod -aG docker centos
ansible-galaxy collection install ansible.posix

# Install kubectl
echo Installing kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Disable firewalld
echo Disabling the firewall
sudo systemctl stop firewalld > /dev/null 2>&1
sudo systemctl disable firewalld > /dev/null 2>&1
echo done

# Disable swap
echo Disabling swap
sudo /usr/sbin/swapoff -a

# Set SELinux to permissive
sudo setenforce 0
sudo sed -i 's/enforcing/permisive/g' /etc/selinux/config

# Get our packages
echo Getting tarballs
echo ....Getting airgapped bundle - This might take 5 mins
mkdir ~/tarballs && cd ~/tarballs
#curl https://s3-us-gov-east-1.amazonaws.com/govcloud.downloads.d2iq.io/dkp/v2.1.1/dkp_airgapped_bundle_v2.1.1_linux_amd64.tar.gz --output airgapped_bundle.tar.gz
#tar -xvf airgapped_bundle.tar.gz --directory ../

# Set up the other nodes
cd /home/centos/ansible
ansible-playbook -i inventory.yaml configure_hosts.yaml
