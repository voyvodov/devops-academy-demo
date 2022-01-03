#!/usr/bin/env bash

set -o pipefail
set -e

ROOTDIR="$( cd -- "$( dirname -- "$(dirname -- "${BASH_SOURCE[0]}")" )" &> /dev/null && pwd )"
ENV=$1
STATE=$2

if [ -z "$ENV" ]; then
 ENV="development"
fi


function apply_ansible() {
  local state=$1
  local state_name=$(basename "$state")
 
  if [[ -e "${ROOTDIR}/ansible/${state_name}.yml" ]]; then
    printf "We have playbook for this state. Will apply ansible..."
    export ANSIBLE_TF_WS_NAME=${ENV}
    export ANSIBLE_TF_DIR=${state}
    ansible-playbook -i "${ROOTDIR}/environments/${ENV}/" "${ROOTDIR}/ansible/${state_name}.yml" --key-file "${ROOTDIR}/secrets/bastion"
  fi 
}

function apply() {
  local state=$1
  local state_name=$(basename "$state")

  pushd "${state}"
  ln -s -f "${ROOTDIR}/environments/${ENV}/${state_name}.tfvars" env.auto.tfvars
  # Below will select or create workspace based on environment name
  terraform workspace select ${ENV} || terraform workspace new ${ENV}
  
  # Disable failure, since we need the exit code
  set +e

  terraform plan -detailed-exitcode -out "${state_name}_${ENV}.plan"
  local tfout=$?
  set -e
  case $tfout in 
    1)
    printf "Terraform plan failed!\n"
    exit 1
    ;;

    0)
    printf "No terraform changes\n"
    apply_ansible "$state"
    ;;

    2)
    read -p "Are you sure you want to apply above plan? [Yy/Nn]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      terraform apply "${state_name}_${ENV}.plan"
    else
      exit 0
    fi
    apply_ansible "$state"
    ;;

    *)
    printf "Unknown exit code %n" "$tfout"
    ;;
  esac
  popd
}

function destroy() {
  local state=$1
  local state_name=$(basename "$state")

  pushd "${state}"
  ln -s -f "${ROOTDIR}/environments/${ENV}/${state_name}.tfvars" env.auto.tfvars
  # Below will select or create workspace based on environment name
  terraform workspace select ${ENV} || terraform workspace new ${ENV}

  set +e
  terraform plan -destroy -out "${state_name}_${ENV}_destroy.plan"
  local tfout=$?
  set -e
  case $tfout in 
    1)
    printf "Terraform plan failed!\n"
    exit 1
    ;;
    0)
    printf "No terraform changes\n"
    ;;

    2)
    read -p "Are you sure you want to apply above plan? [Yy/Nn]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      terraform apply "${state_name}_${ENV}_destroy.plan"
    else
      exit 0
    fi
    apply_ansible "$state"
    ;;
  esac
  popd
}

printf "Going to use '%s' environment\n" $ENV

if [[ -z $STATE ]];then 
  for state in "${ROOTDIR}"/terraform/states/*/;do
    apply "$state"
  done 
else
  print "Will apply a single state ${STATE}/n"
  apply "${ROOTDIR}/terraform/states/${STATE}"
fi
