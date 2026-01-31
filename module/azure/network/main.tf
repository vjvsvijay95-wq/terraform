provider "azurerm" {
  subscription_id = var.subscription_id
  resource_provider_registrations = "none"
  features {}
}


resource "azurerm_resource_group" "rg" {
  name = "sloopstash-prd"
  location = "Central India"
  tags = {
    Name = "sloopstash-prd"
    Environment = var.environment
    Region = "centralindia"
    Organization = "sloopstash"
  }
}

resource "azurerm_virtual_network" "vnet" {
  depends_on = [azurerm_resource_group.rg]
  name = "vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  address_space = ["11.1.0.0/16"]
  encryption {
    enforcement = "AllowUnencrypted"
  }
  tags = {
    Name = "vnet"
    Environment = var.environment
    Region = "centralindia"
    Organization = "sloopstash"
  }
}
 