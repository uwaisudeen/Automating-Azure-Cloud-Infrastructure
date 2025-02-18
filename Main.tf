
# Fetch JSON data from Google Sheets API
data "external" "google_form_input" {
  program = ["python3", "${path.module}/fetch_input.py"]
}

resource "azurerm_resource_group" "rg" {
  name     = "web-input-resources"
  location = "East US"
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "myVNet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = { for vm in data.external.google_form_input.result : vm["vm_name"] => vm }

  name                  = each.value["vm_name"]
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = each.value["size"]
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.nic.id]  # Replace with actual NIC creation


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = each.value["image"]
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
resource "azurerm_network_interface" "nic" {
  name                = "my-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    
  }
}