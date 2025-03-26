#!/bin/bash

# nodes
MASTER="master"
WORKER="worker"

# task
TASK_DIR=$(dirname "$0")

# ssh connection config
SSH_SESSION_DIR="$TASK_DIR/.ssh"
SSH_CONFIG_FILE="config"
SSH_CONFIG_PATH="$SSH_SESSION_DIR/$SSH_CONFIG_FILE"
SSH_CONFIG="-F $SSH_CONFIG_PATH"

# scripts
SCRIPTS_DIR="$TASK_DIR/scripts"
MASTER_HOME="~"
MACHINE_K8S_DIR="$MASTER_HOME/k8s/"

configure_ssh() {
  mkdir -p "$SSH_SESSION_DIR"
  vagrant ssh-config > "$SSH_CONFIG_PATH"
}

execute_script() {
  local SCRIPT_NAME="$1"
  local TARGET_NODE="$2"
  local SCRIPT_PATH="$SCRIPTS_DIR/$SCRIPT_NAME"

  ssh $SSH_CONFIG $TARGET_NODE "mkdir -p $MACHINE_K8S_DIR"
  scp $SSH_CONFIG $SCRIPT_PATH $TARGET_NODE:$MACHINE_K8S_DIR
  ssh $SSH_CONFIG $TARGET_NODE "bash $MACHINE_K8S_DIR/$SCRIPT_NAME"
}

reset() {
  execute_script "reset.sh" "$1"
}

install() {
  execute_script "install.sh" "$1"
}

init() {
  execute_script "master.sh" "$1"
}

join() {
  local MASTER_HOSTNAME="$1"
  local WORKER_HOSTNAME="$2"

  GET_NODES_CMD="kubectl get nodes --no-headers"
  CHECK_NODE_CMD="$GET_NODES_CMD | grep -w $WORKER_HOSTNAME >/dev/null 2>&1"
  if ssh $SSH_CONFIG $MASTER_HOSTNAME $CHECK_NODE_CMD; then
    return 0
  fi

  PRINT_TOKEN_CMD="sudo kubeadm token create --print-join-command"
  JOIN_CMD=$(ssh $SSH_CONFIG $MASTER_HOSTNAME $PRINT_TOKEN_CMD)
  ssh $SSH_CONFIG $WORKER_HOSTNAME "sudo $JOIN_CMD"
}

pull_kubeconfig() {
  GET_CONFIG_FILE_CMD="cat $MASTER_HOME/.kube/config"
  ssh $SSH_CONFIG $MASTER $GET_CONFIG_FILE_CMD > "$HOME/.kube/config"
}

cleanup() {
  rm -r "$SSH_SESSION_DIR"
}

print_help() {
  echo "Usage: $0"
  echo "  --install - Install Kubernetes"
  echo "  --deploy  - Deploy Kubernetes"
  echo "  --reset   - Resets the Kubernetes cluster"
  echo "  --help    - Show this help message"
}

case "$1" in
  --install)
    configure_ssh
    install $MASTER
    install $WORKER
    cleanup
    ;;
  --deploy)
    configure_ssh
    init $MASTER
    join $MASTER $WORKER
    pull_kubeconfig
    cleanup
    ;;
  --reset)
    configure_ssh
    reset $MASTER
    reset $WORKER
    cleanup
    ;;
  --help|*)
    print_help
    ;;
esac
