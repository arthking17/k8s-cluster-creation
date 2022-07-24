#!/bin/sh

# var MASTER_PUBLIC_IP_ADDRESS
curl --request PUT --header "PRIVATE-TOKEN: glpat-RqJrzJQeATHqi392iMgD" "https://gitlab.com/api/v4/groups/38341705/variables/MASTER_PUBLIC_IP_ADDRESS" --form "value=$(terraform output master_public_ip_address)"

# var WORKER_PUBLIC_IP_ADDRESS
curl --request PUT --header "PRIVATE-TOKEN: glpat-RqJrzJQeATHqi392iMgD" "https://gitlab.com/api/v4/groups/38341705/variables/WORKER_PUBLIC_IP_ADDRESS" --form "value=$(terraform output worker_public_ip_address)"

# update inventory file for ansible-playbook (var INVENTORY_K8S_CLUSTER type file)
curl --request PUT --header "PRIVATE-TOKEN: glpat-RqJrzJQeATHqi392iMgD" "https://gitlab.com/api/v4/groups/38341705/variables/INVENTORY_K8S_CLUSTER" \
--form "value=[master]
$(terraform output master_public_ip_address) ansible_ssh_user=william ansible_ssh_private_key_file=/azure/.ssh/id_rsa

[worker]
$(terraform output worker_public_ip_address) ansible_ssh_user=william ansible_ssh_private_key_file=/azure/.ssh/id_rsa
"