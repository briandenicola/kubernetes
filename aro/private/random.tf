resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

resource "random_integer" "vnet_cidr" {
  min = 10
  max = 250
}

resource "random_integer" "services_cidr" {
  min = 64
  max = 90
}

resource "random_integer" "pod_cidr" {
  min = 91
  max = 127
}

resource "random_password" "password" {
  length           = 30
  special          = true
  override_special = "!@#^&*()_+"
  min_lower        = 1
  min_numeric      = 2
  min_special      = 1
  min_upper        = 1
}
