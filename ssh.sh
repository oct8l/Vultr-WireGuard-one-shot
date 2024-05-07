#!/bin/bash

export WGIP=`cat terraform/terraform.tfstate | jq -r '.outputs .public_ip .value[0]'`

ssh wireguarder@$WGIP -i id_rsa
