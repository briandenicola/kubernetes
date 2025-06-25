locals {
  bastion_name   = "${var.resource_name}-bastion"
  location       = var.vm.location
  non_az_regions = ["northcentralus", "canadaeast", "westcentralus", "westus"]
}
