resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

resource "random_integer" "vnet_cidr" {
  min = 10
  max = 25
}

resource "random_integer" "services_cidr" {
  min = 65
  max = 87
}

resource "random_integer" "pod_cidr" {
  min = 127
  max = 192
}