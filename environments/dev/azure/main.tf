module "azure_vm" {
  source = "../../terraform-modules/azure/vm"

  name                = "example-vm"
  location            = "eastus"
  resource_group_name = "example-resource-group"
}
