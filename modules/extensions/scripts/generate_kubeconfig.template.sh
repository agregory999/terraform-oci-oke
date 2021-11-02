#!/bin/bash
# Copyright 2017, 2021 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

if [ ! -f $HOME/.kube/config ]; then

  # For command
  for row in `oci ce cluster list -c ${compartment_id} --lifecycle-state ACTIVE --query "data[].{OCID:id,Name:name}" | jq -c -r '.[] '`
  do
    name=$(echo $row | jq -r '.Name')
    ocid=$(echo $row | jq -r '.OCID')
    echo "checking cluster $name | $ocid"
    oci ce cluster create-kubeconfig --cluster-id $ocid --file $HOME/.kube/config --region ${region} --token-version 2.0.0 --auth instance_principal --kube-endpoint PRIVATE_ENDPOINT
    kubectl config rename-context $(kubectl config current-context) $name
  done
  chmod go-r $HOME/.kube/config
fi