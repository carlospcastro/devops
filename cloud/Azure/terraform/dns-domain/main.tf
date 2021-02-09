provider "azurerm" {
  version = "=2.5.0"
  features {}
}

resource "azurerm_resource_group" "dnsdomain" {
  name     = "rg-internal-dns"
  location = var.location
}

resource "azurerm_dns_zone" "dnsdomain-public" {
  name                = var.domain-name
  resource_group_name = azurerm_resource_group.dnsdomain.name
}

resource "azurerm_private_dns_zone" "dnsdomain-private" {
  name                = var.domain-name
  resource_group_name = azurerm_resource_group.dnsdomain.name
}