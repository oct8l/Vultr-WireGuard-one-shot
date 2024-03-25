#!/bin/bash

export WGIP=`cat terraform/terraform.tfstate | jq -r '.resources[3] .instances[0] .attributes .main_ip'`

ssh wireguarder@$WGIP -i id_rsa
