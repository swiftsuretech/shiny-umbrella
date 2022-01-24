resource "local_file" "setup_bastion" {
  filename = "setup_bastion"
  content  = <<EOF
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
curl https://s3-us-gov-east-1.amazonaws.com/govcloud.downloads.d2iq.io/dkp/v2.1.1/dkp_airgapped_bundle_v${var.dkpversion}_linux_amd64.tar.gz --output airgapped_bundle.tar.gz
tar -xvf airgapped_bundle.tar.gz --directory ../

# Set up the other nodes
echo Prepping cluster nodes
cd /home/centos/configuration
ansible-playbook -i inventory.yaml configure_hosts.yaml

# Running initial setup
cd /home/centos/dkp-v${var.dkpversion}
sleep 10
sudo ./setup
cd kib
cp /home/centos/configuration/inventory.yaml /home/centos/dkp-v${var.dkpversion}
source <(ssh-agent)
ssh-add /home/centos/.ssh/*.pem

# Build our Image
cp /home/centos/coniguration/inventory.yaml /home/centos/dkp-v${var.dkpversion}/kib/inventory.yaml
./konvoy-image provision --inventory-file inventory.yaml --overrides overrides-bundles.yaml
cd ..

# Spin up the bootstrap
cp /home/centos/.ssh/${var.key} /home/centos/dkp-v${var.dkpversion}/$var.key
cp /home/centos/configuration/cluster-pp.sh /home/centos/dkp-v${var.dkpversion}/cluster-pp.sh
echo Spinning up the bootstrap node
./cluster-pp.sh

# Create the konvoy cluster
echo spinning up the konvoy cluster
cp /home/centos/configuration/cluster-sbx.yaml /home/centos/dkp-v${var.dkpversion}/cluster-sbx.yaml
kubectl apply -f cluster-sbx.yaml

# Wait for boostrap CP
echo Waiting for our Bootstrap Control Plane to come online
while [ $(k get nodes | grep Ready | wc -l) -ne 0 ]; do
  echo Waiting for Bootstrap Control Plane
  sleep 10
done

# Snag the new kubeconfig 
echo Bootstrap control plane is live, getting our kubeconfig
./dkp get kubeconfig -c cluster-sbx > admin.conf

# Check our konvoy nodes
echo Waiting for all nodes to come up
while [ $(kubectl --kubeconfig=admin.conf get nodes | grep Ready | wc -l) -lt 7 ]; do
  echo Waiting for all nodes to come up. Currently $(kubectl --kubeconfig=admin.conf get nodes | grep Ready | wc -l) of 7.
  sleep 10
done

# Shifting bootstrap controller to the cluster
echo Moving bootstrap controllers to the cluster
./dkp create bootstrap controllers --with-aws-bootstrap-credentials=false --kubeconfig admin.conf

###################################################
############### Konvoy Deployed ###################
###################################################





EOF
}
