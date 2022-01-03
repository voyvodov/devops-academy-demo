#!/usr/bin/env bash

set -o pipefail
set -e

ROOTDIR="$( cd -- "$( dirname -- "$(dirname -- "${BASH_SOURCE[0]}")" )" &> /dev/null && pwd )"
ENV=$1

if [ -z "$ENV" ]; then
 ENV="development"
fi


printf "Going to use '%s' environment\n" $ENV


for state in "${ROOTDIR}"/terraform/states/*/;do 
  state_name=$(basename "$state")
  pushd "${state}"
  ln -s -f "${ROOTDIR}/environments/${ENV}/${state_name}.tfvars" env.auto.tfvars
  popd
done 



# pushd "${ROOTDIR}/terraform/states/workloads"
# ln -s -f "${ROOTDIR}/environments/${ENV}/env.tfvars" env.auto.tfvars
# popd