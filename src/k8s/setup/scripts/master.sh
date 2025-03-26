#!/bin/bash
set -e

init_cluster() {
  sudo kubeadm init --pod-network-cidr=10.244.0.0/16
}

setup_kubectl_config() {
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
}

apply_flannel() {
  GITHUB_RAW="https://raw.githubusercontent.com"
  KUBE_FLANNEL="coreos/flannel/master/Documentation/kube-flannel.yml"
  FLANNEL="$GITHUB_RAW/$KUBE_FLANNEL"
  kubectl apply -f $FLANNEL
}

execute() {
  if [ ! -f $HOME/.kube/config ]; then
    init_cluster
    setup_kubectl_config
  fi
  apply_flannel
}

execute