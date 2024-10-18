variable "resource_group" {
  description = "Resource Group"
  type = object({
    name     = string
    location = string
  })
}

variable "virtual_wan" {
  description = "Virtual WAN"
  type = object({
    name     = string
    location = string
  })
}

variable "virtual_hub" {
  description = "Virtual Hub"
  type = object({
    name           = string
    location       = string
    address_prefix = string
  })
}

variable "virtual_network" {
  description = "Virtual Network"
  type = object({
    name          = string
    location      = string
    address_space = list(string)
  })
}

