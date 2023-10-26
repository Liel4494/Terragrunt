provider "azurerm" {
  features {}
}

resource "azurerm_virtual_machine" "example" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  // Additional configurations...
  network_interface_ids = []
  vm_size               = ""
}
