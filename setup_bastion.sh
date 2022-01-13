#!/bin/bash

# Install docker
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum -y install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo usermod -aG docker centos

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Disable swap
swapoff -a
