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

variable "virtual_hub_routing_intent" {
  description = "Virtual Hub Routing Intent"
  type = object({
    name = string
  })
}

variable "firewall_policy" {
  description = "Firewall Policy"
  type = object({
    name     = string
    location = string
    sku      = string
    dns = object({
      proxy_enabled = bool
      servers       = list(string)
    })
    threat_intelligence_mode = optional(string, null)
  })
}

variable "azfirewall" {
  description = "Azure Firewall"
  type = object({
    name            = string
    location        = string
    sku_name        = string
    sku_tier        = string
    public_ip_count = number
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

variable "virtual_network_subnets" {
  description = "Virtual Network Subnets"
  type = list(object({
    name           = string
    address_prefix = list(string)
  }))
}

variable "private_dns_zones" {
  description = "Private DNS Zones"
  type = list(object({
    name = string
  }))
}
