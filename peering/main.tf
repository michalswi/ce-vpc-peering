
variable "vm1_network" {
  description = "vm1's vpc network id"
}

variable "vm2_network" {
  description = "vm2's vpc network id"
}

module "peering1" {
  source        = "terraform-google-modules/network/google//modules/network-peering"
  version       = "~> 5.2"
  local_network = var.vm1_network
  peer_network  = var.vm2_network
}
