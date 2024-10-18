resource "azurerm_resource_group" "rg" {
    name = var.resource_group.location
    location = var.resource_group.location
}

resource "azurerm_virtual_wan" "vwan" {
    name = var.virtual_wan.name
    resource_group_name = azurerm_resource_group.rg.name
    location = coalesce(var.virtual_wan.location, azurerm_resource_group.rg.location)
}

resource "azurerm_virtual_hub" "vhub" {
    name = var.virtual_hub.name
    resource_group_name = azurerm_resource_group.rg.name
    location = coalesce(var.virtual_hub.location, azurerm_resource_group.rg.location)
    virtual_wan_id = azurerm_virtual_wan.vwan.id
    address_prefix = var.virtual_hub.address_prefix
}

resource "azurerm_firewall" "azfirewall" {
    name = var.azfirewall.name
    resource_group_name = azurerm_resource_group.rg.name
    location = coalesce(var.azfirewall.location, azurerm_resource_group.rg.location)
    sku_name = var.azfirewall.sku_name
    sku_tier = var.azfirewall.sku_tier
    virtual_hub {
        virtual_hub_id = azurerm_virtual_hub.vhub.id
    }
}

resource "azurerm_virtual_network" "vnet" {
    name = var.virtual_network.name
    resource_group_name = azurerm_resource_group.rg.name
    location = coalesce(var.virtual_network.location, azurerm_resource_group.rg.location)
    address_space = var.virtual_network.address_space
}

resource "azurerm_virtual_hub_connection" "vhub_connection" {
    name 