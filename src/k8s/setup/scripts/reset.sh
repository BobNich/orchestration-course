#!/bin/bash
set -e

reset() {
  sudo kubeadm reset -f
}

stop_kubelet() {
  sudo systemctl disable --now kubelet || true
}

remove_configurations() {
  sudo rm -r $HOME/.kube/config || true
}

execute() {
  reset
  stop_kubelet
  remove_configurations
}

execute