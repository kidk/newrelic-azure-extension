# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.36.0"
}

variable "newrelic_license_key" {
  type = "string"
}

variable "machine_username" {
  type = "string"
}

variable "machine_password" {
  type = "string"
}

# Create a resource group
resource "azurerm_resource_group" "infra" {
  name     = "newrelic-infra"
  location = "West Europe"
}

# Create virtual network
resource "azurerm_virtual_network" "network" {
  name                = "infra-net"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = "${azurerm_resource_group.infra.name}"
  location            = "${azurerm_resource_group.infra.location}"
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "infra-subnet"
  resource_group_name  = "${azurerm_resource_group.infra.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create a security group (Allow SSH)
resource "azurerm_network_security_group" "security-group" {
  name                = "infra-security-group"
  location            = "${azurerm_resource_group.infra.location}"
  resource_group_name = "${azurerm_resource_group.infra.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

