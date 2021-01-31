provider "azurerm" {
  version = "=2.5.0"

  subscription_id = var.subscription_id
  client_id       = var.service_principal_id
  client_secret   = var.service_principal_key
  tenant_id       = var.tenant_id

  features {}
}

module "aks" {
  source                = "../modules/aks/"
  service_principal_id  = var.service_principal_id
  service_principal_key = var.service_principal_key
  ssh_key               = var.ssh_key
  location              = var.location
  kubernetes_version    = var.kubernetes_version
}