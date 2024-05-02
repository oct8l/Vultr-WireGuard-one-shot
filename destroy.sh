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


###########################################################################
## Notify about the python packages installed in the `run-all.sh` script ##
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

printf "If you no longer need the Python packages, you can uninstall them with:\n\n"
printf "pip uninstall -r \"%s/requirements.txt\" -y\n\n" "${SCRIPT_DIR}"
###########################################################################


printf "\n\e[32m---------\nALL GONE\n---------\e[0m\n\n"
