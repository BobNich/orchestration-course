#!/bin/bash
set -e

disable_swap() {
  sudo swapoff -a
  sudo sed -i '/ swap / s/^/#/' /etc/fstab
}

persist_required_system_values() {
  cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
  overlay
  br_netfilter
EOF

  sudo modprobe overlay
  sudo modprobe br_netfilter

  cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
  net.bridge.bridge-nf-call-iptables  = 1
  net.bridge.bridge-nf-call-ip6tables = 1
  net.ipv4.ip_forward                 = 1
EOF

  sudo sysctl --system
}

add_k8s_repository_gpg() {
  sudo mkdir -p /etc/apt/keyrings

  if [ ! -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]; then
    sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  fi

  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
  https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" |
  sudo tee /etc/apt/sources.list.d/kubernetes.list

  sudo apt-get update
}

add_containerd() {
  if ! command -v containerd >/dev/null; then
    sudo apt-get install -y containerd.io
  fi
}

install_k8s_dependencies() {
  sudo apt-get install -y --allow-change-held-packages \
    kubelet \
    kubeadm
  sudo apt-mark hold \
    kubelet \
    kubeadm
}

enable_kubelet() {
  sudo systemctl enable --now kubelet
}

execute() {
  disable_swap
  persist_required_system_values
  add_k8s_repository_gpg
  add_containerd
  install_k8s_dependencies
  enable_kubelet
}

execute