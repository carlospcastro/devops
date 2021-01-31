resource "azurerm_resource_group" "aks-test01" {
  name     = "aks-test01"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks-test01" {
  name                  = "aks-test01"
  location              = azurerm_resource_group.aks-test01.location
  resource_group_name   = azurerm_resource_group.aks-test01.name
  dns_prefix            = "aks-test01"            
  kubernetes_version    =  var.kubernetes_version
  
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v4"
    os_disk_size_gb = 30
  }

  service_principal  {
    client_id = var.service_principal_id
    client_secret = var.service_principal_key
  }

  linux_profile {
    admin_username = "testuser"
    ssh_key {
        key_data = var.ssh_key
    }
  }

  network_profile {
      network_plugin = "kubenet"
      load_balancer_sku = "Standard"
  }

}