resource "azurerm_network_interface" "suse" {
  name                = "suse-nic"
  location            = "${azurerm_resource_group.infra.location}"
  resource_group_name = "${azurerm_resource_group.infra.name}"

  ip_configuration {
    name                          = "suse-configuration"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "suse" {
  name                  = "suse-vm"
  location              = "${azurerm_resource_group.infra.location}"
  resource_group_name   = "${azurerm_resource_group.infra.name}"
  network_interface_ids = ["${azurerm_network_interface.suse.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "suse-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "SUSE"
    offer     = "SLES"
    sku       = "12.4"
    version   = "latest"
  }

  os_profile {
    computer_name  = "suse-vm"
    admin_username = "${var.machine_username}"
    admin_password = "${var.machine_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}

resource "azurerm_virtual_machine_extension" "suse" {
  name                 = "suse-custom"
  location             = "${azurerm_resource_group.infra.location}"
  resource_group_name  = "${azurerm_resource_group.infra.name}"
  virtual_machine_name = "${azurerm_virtual_machine.suse.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/kidk/newrelic-azure-extension/master/linux/script.sh"],
        "commandToExecute": "bash script.sh ${var.newrelic_license_key}"
    }
SETTINGS

}
