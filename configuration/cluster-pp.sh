#!/usr/bin/env bash

CLUSTER_SUFFIX=SBX
readonly CLUSTER_NAME=cluster-${CLUSTER_SUFFIX,,}

# ON PREM CONFIGS

###################################
#### SET ENVIRONMENT VARIABLES ####
###################################

readonly CONTROL_PLANE_1_ADDRESS="10.0.0.20"
readonly CONTROL_PLANE_2_ADDRESS="10.0.0.21"
readonly CONTROL_PLANE_3_ADDRESS="10.0.0.22"
readonly WORKER_1_ADDRESS="10.0.0.30"
readonly WORKER_2_ADDRESS="10.0.0.31"
readonly WORKER_3_ADDRESS="10.0.0.32"
readonly WORKER_4_ADDRESS="10.0.0.33"
readonly SSH_USER="centos"
readonly SSH_PRIVATE_KEY_SECRET_NAME="${CLUSTER_NAME}-ssh-key"
readonly SSH_PRIVATE_KEY="./btsec-pov-2.pem"
readonly SECRET_USER_OVERRIDES=${CLUSTER_NAME}-user-overrides
readonly SSH_PORT=22
readonly CONTROL_PLANE_NAME=${CLUSTER_NAME}-control-plane
readonly WORKER_NAME=${CLUSTER_NAME}-md-0
readonly CONTROL_PLANE_VIP=10.0.0.20
readonly CONTROL_PLANE_VIP_PORT=6443
readonly CONTROL_PLANE_VIP_INTERFACE=eth0
readonly DOCKER_REGISTRY_ADDRESS=http://$(hostname -I | awk '{print $1}'):5000


##################################
#### CREATE BOOTSTRAP CLUSTER ####
##################################

./dkp create bootstrap --with-aws-bootstrap-credentials=false


#########################################
#### CREATE SSH AND OVERRIDE SECRETS ####
#########################################

# CREATE SSH SECRET FROM EXISTING KEY
kubectl create secret generic ${SSH_PRIVATE_KEY_SECRET_NAME} --from-file=ssh-privatekey=${SSH_PRIVATE_KEY}

kubectl label secret ${SSH_PRIVATE_KEY_SECRET_NAME} clusterctl.cluster.x-k8s.io/move=

# CREATE OVERRIDES SECRET

cat << EOF | kubectl create secret generic ${SECRET_USER_OVERRIDES} --from-file=overrides.yaml=/dev/stdin
image_registries_with_auth:
- host: ${DOCKER_REGISTRY_ADDRESS}
  username: ""
  password: ""
  auth: ""
  identityToken: ""
download_images: false
EOF

kubectl label secret ${SECRET_USER_OVERRIDES} clusterctl.cluster.x-k8s.io/move=


########################################################
#### CREATE AND APPLY PREPROVISIONED INVENTORY FILE ####
########################################################

cat <<EOF | kubectl apply -f -
---
apiVersion: infrastructure.cluster.konvoy.d2iq.io/v1alpha1
kind: PreprovisionedInventory
metadata:
  name: ${CONTROL_PLANE_NAME}
  namespace: default
  labels:
    cluster.x-k8s.io/cluster-name: ${CLUSTER_NAME}
    clusterctl.cluster.x-k8s.io/move: ""
spec:
  hosts:
    # Create as many of these as needed to match your infrastructure
    - address: ${CONTROL_PLANE_1_ADDRESS}
    - address: ${CONTROL_PLANE_2_ADDRESS}
    - address: ${CONTROL_PLANE_3_ADDRESS}
  sshConfig:
    port: ${SSH_PORT}
    # This is the username used to connect to your infrastructure. This user must be root or
    # have the ability to use sudo without a password
    user: ${SSH_USER}
    privateKeyRef:
      # This is the name of the secret you created in the previous step. It must exist in the same
      # namespace as this inventory object.
      name: ${SSH_PRIVATE_KEY_SECRET_NAME}
      namespace: default
---
apiVersion: infrastructure.cluster.konvoy.d2iq.io/v1alpha1
kind: PreprovisionedInventory
metadata:
  name: ${WORKER_NAME}
  namespace: default
  labels:
    clusterctl.cluster.x-k8s.io/move: ""
spec:
  hosts:
    - address: ${WORKER_1_ADDRESS}
    - address: ${WORKER_2_ADDRESS}
    - address: ${WORKER_3_ADDRESS}
    - address: ${WORKER_4_ADDRESS}
  sshConfig:
    port: ${SSH_PORT}
    user: ${SSH_USER}
    privateKeyRef:
      name: ${SSH_PRIVATE_KEY_SECRET_NAME}
      namespace: default
EOF


########################
#### CREATE CLUSTER ####
########################

#default CONTROL PLANE VIP Port is 6443

./dkp create cluster preprovisioned \
    --with-aws-bootstrap-credentials=false \
    --cluster-name ${CLUSTER_NAME} \
    --control-plane-endpoint-host ${CONTROL_PLANE_VIP} \
    --control-plane-endpoint-port ${CONTROL_PLANE_VIP_PORT} \
    --override-secret-name ${SECRET_USER_OVERRIDES} \
    --registry-mirror-url ${DOCKER_REGISTRY_ADDRESS} \
    --virtual-ip-interface ${CONTROL_PLANE_VIP_INTERFACE} \
    --dry-run \
    -o yaml > ${CLUSTER_NAME}.yaml