Telerik Academy DevOps Demo
====

## How to apply

Ensure that you have AWS profile named __```tlrk```__ with needed secret/access key.

```bash
./bin/apply.sh development
```

## How to destroy
```bash
# Destroy workloads
pushd terraform/states/workloads
terraform destroy
popd

# Destroy base
pushd terraform/states/base
terraform destroy
popd
```