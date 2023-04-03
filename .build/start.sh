#!/bin/bash

# Run this script as follows: ./.build/start.sh, 

export NAME="[start.sh] "

set -eE -o functrace
failure() {
  local lineno=$1
  local msg=$2
  echo "${NAME} Failed at $lineno: $msg"
}

create_k8s_elements() 
{
  echo "Creating $1"
  find -name $1 -type d | while read line; do
      files=`ls $line`

      if [[ $files ]]; then
        kubectl apply -f $line
      fi 
  done
}

create_k8s_elements "config_maps"
create_k8s_elements "secrets"
create_k8s_elements "pv"
create_k8s_elements "pvc"
create_k8s_elements "state"

kubectl apply -f "ingress.yml"