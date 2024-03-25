terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = ">= 2.19.0"
    }
  }
}

# Configure the Vultr Provider
provider "vultr" {
  api_key = var.APIKEY
  rate_limit = 100
  retry_limit = 3
}

# Create a server
resource "vultr_instance" "wireguard-rc" {
    plan                = "vc2-1c-1gb"
    region              = "dfw"
    os_id               = "1743"
    enable_ipv6         = false
    firewall_group_id   = vultr_firewall_group.wg_fw_grp.id
    hostname            = "wireguard-rc"
    user_data           = (templatefile("${path.module}/cloud-init.yaml", local.templatevars))
    label               = "wireguard-rc"
}

resource "vultr_firewall_group" "wg_fw_grp" {
    description = "WireGuard server group"
}
resource "vultr_firewall_rule" "allow_ssh" {
    firewall_group_id = vultr_firewall_group.wg_fw_grp.id
    protocol = "tcp"
    ip_type = "v4"
    subnet = "0.0.0.0"
    subnet_size = 0
    port = "22"
    notes= "Allow SSH in"
}
resource "vultr_firewall_rule" "allow_wg" {
    firewall_group_id = vultr_firewall_group.wg_fw_grp.id
    protocol = "udp"
    ip_type = "v4"
    subnet = "0.0.0.0"
    subnet_size = 0
    port = "51820"
    notes= "Allow WireGuard in"
}

locals {
  templatevars = {
    init_public_key   = var.pubkey,
    init_ssh_username = var.ssh_username,
    init_ssh_pass     = var.ssh_pass
  }
}

variable "pubkey" {
  type        = string
}

variable "ssh_username" {
  type        = string
  description = "Username to set up"
  default     = "wireguarder"
}

variable "ssh_pass" {
  type        = string
  description = "Password for the specified user"
  default     = ""
  sensitive   = true
}

variable "APIKEY" {
    type      = string
}

output "public_ip" {
    value     = [vultr_instance.wireguard-rc.main_ip]
}

output "public_ipv6" {
    value     = [vultr_instance.wireguard-rc.v6_main_ip]
}
