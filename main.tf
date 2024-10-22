resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

resource "azurerm_virtual_wan" "vwan" {
  name                = var.virtual_wan.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = coalesce(var.virtual_wan.location, azurerm_resource_group.rg.location)
}

resource "azurerm_virtual_hub" "vhub" {
  name                = var.virtual_hub.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = coalesce(var.virtual_hub.location, azurerm_resource_group.rg.location)
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = var.virtual_hub.address_prefix
}


resource "azurerm_virtual_hub_routing_intent" "vhub_routing_intent" {
  name           = var.virtual_hub_routing_intent.name
  virtual_hub_id = azurerm_virtual_hub.vhub.id

  routing_policy {
    name         = "_policy_PublicTraffic"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.azfirewall.id
  }
  routing_policy {
    name         = "_policy_PrivateTraffic"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.azfirewall.id
  }
}


resource "azurerm_firewall_policy" "azfwpolicy" {
  name                     = var.firewall_policy.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = coalesce(var.firewall_policy.location, azurerm_resource_group.rg.location)
  sku                      = var.firewall_policy.sku
  threat_intelligence_mode = var.firewall_policy.threat_intelligence_mode

  dns {
    proxy_enabled = var.firewall_policy.dns.proxy_enabled
    servers       = var.firewall_policy.dns.servers
  }
  intrusion_detection {
    mode = "Alert"
  }
}

resource "azurerm_firewall" "azfirewall" {
  name                = var.azfirewall.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = coalesce(var.azfirewall.location, azurerm_resource_group.rg.location)
  sku_name            = var.azfirewall.sku_name
  sku_tier            = var.azfirewall.sku_tier
  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.vhub.id
    public_ip_count = var.azfirewall.public_ip_count
  }
  firewall_policy_id = azurerm_firewall_policy.azfwpolicy.id
}


resource "azurerm_virtual_network" "hubvnet" {
  name                = var.virtual_network.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = coalesce(var.virtual_network.location, azurerm_resource_group.rg.location)
  address_space       = var.virtual_network.address_space
}

resource "azurerm_subnet" "hubsubnets" {
  count                = length(var.virtual_network_subnets)
  name                 = var.virtual_network_subnets[count.index].name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hubvnet.name
  address_prefixes     = var.virtual_network_subnets[count.index].address_prefix
}

resource "azurerm_virtual_hub_connection" "hubvnet_connection" {
  name                      = "${azurerm_virtual_hub.vhub.name}-to-${azurerm_virtual_network.hubvnet.name}"
  virtual_hub_id            = azurerm_virtual_hub.vhub.id
  remote_virtual_network_id = azurerm_virtual_network.hubvnet.id
  internet_security_enabled = true
}

## nsg's
## ip groups
## vpns
## rune collections

