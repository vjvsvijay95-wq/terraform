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

resource "azurerm_subnet" "container_s2_vnet_aks_sn_1" {
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_virtual_network.vnet
  ]
  name = "container-s2-vnet-aks-sn-1"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["11.1.3.0/24"]
}
resource "azurerm_subnet" "container_s2_vnet_aks_sn_2" {
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_virtual_network.vnet
  ]
  name = "container-s2-vnet-aks-sn-2"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["11.1.4.0/24"]
}

resource "azurerm_kubernetes_cluster" "container_s2_aks_ct" {
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_subnet.container_s2_vnet_aks_sn_1,
    azurerm_subnet.container_s2_vnet_aks_sn_2
  ]
  name = "container-s2-aks-ct"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  kubernetes_version = "1.32.0"
  sku_tier = "Free"
  identity {
    type = "SystemAssigned"
  }
  open_service_mesh_enabled = false
  private_cluster_enabled = false
  dns_prefix = "container-s2-aks-ct-api-endpoint"
  api_server_access_profile {
    authorized_ip_ranges = ["0.0.0.0/0"]
  }
  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
    ip_versions = ["IPv4"]
    load_balancer_sku = "standard"
  }
  node_resource_group = "container-s2-aks-ct-rg"
  default_node_pool {
    name = "nodepool1"
    vm_size = "Standard_D2as_v4"
    type = "VirtualMachineScaleSets"
    os_sku = "AzureLinux"
    vnet_subnet_id = azurerm_subnet.container_s2_vnet_aks_sn_1.id
    node_public_ip_enabled = false
    ultra_ssd_enabled = false
    host_encryption_enabled = false
    orchestrator_version = "1.32.0"
    workload_runtime = "OCIContainer"
    auto_scaling_enabled = true
    max_count = 1
    min_count = 1
    node_count = 1
    max_pods = 50
  }
  automatic_upgrade_channel = "patch"
  node_os_upgrade_channel = "NodeImage"
  maintenance_window {
    allowed {
      day = "Sunday"
      hours = [1,2]
    }
  }
  role_based_access_control_enabled = true
  azure_policy_enabled = false
  image_cleaner_enabled = false
  oidc_issuer_enabled = false
  run_command_enabled = true
  tags = {
    Name = "container-s2-aks-ct"
    Environment = var.environment
    Region = "centralindia"
    Organization = "sloopstash"
  }
}