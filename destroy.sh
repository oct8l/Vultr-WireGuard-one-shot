#!/bin/bash

#########################
## Delete the SSH keys ##
rm id_rsa*
#########################

############################################################
## Go into the Terraform directory and provision the host ##
cd terraform
terraform destroy -auto-approve
############################################################

########################################################
## Go into the Ansible directory and run the playbook ##
cd ../ansible
rm -rf clients/
########################################################

printf "\nALL GONE\n\n"
