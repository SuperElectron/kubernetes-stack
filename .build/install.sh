#!/bin/bash

# Run this script as follows: ./install.sh,

export NAME="[install.sh] "

set -eE -o functrace
failure() {
  local lineno=$1
  local msg=$2
  echo "${NAME} Failed at $lineno: $msg"
}

echo "${NAME} Downloading k8s"
cd /tmp && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
cd /tmp && curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
cd /tmp && echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
cd /tmp && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo "${NAME} Clean up downloads"
cd /tmp && rm -rf kubectl kubectl.sha256

echo "${NAME} Testing installation"
export TEST="$(test -f /usr/local/bin/kubectl && echo 'yes' || echo 'no')"
if [[ "$TEST" == 'no' ]]; then
  echo "--(test:fail)-- could not run: /usr/local/bin/kubectl "
  exit -1;
else
  echo "--(test)-- Install success: kubectl version --client --output=yaml "
  kubectl version --client --output=yaml
fi

cd /tmp && curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
cd /tmp && sudo install minikube-linux-amd64 /usr/local/bin/minikube
cd /tmp && rm -rf minikube-linux-amd64

mkdir -p $HOME/.kube
echo "\n\n****************"
echo "Add to your ~/.bashrc or ~/.zshrc: alias kubectl=\"minikube kubectl --\""
echo "Run these commands to get started"
echo "$ minikube start"
echo "$ kubectl cluster-info"
echo "\n\n****************"
echo "${NAME} Finished"