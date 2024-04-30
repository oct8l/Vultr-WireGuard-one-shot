#!/bin/bash

#########################
## Delete the SSH keys ##
rm id_rsa*
#########################


#############################################
## Set a junk variable so destroying works ##
export TF_VAR_pubkey=junk
#############################################


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


########################################################################
## Uninstall the python packages installed in the `run-all.sh` script ##
pip uninstall -r requirements.txt -y
########################################################################

printf "\nALL GONE\n\n"
