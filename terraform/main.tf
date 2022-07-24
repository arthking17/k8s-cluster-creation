resource "random_pet" "rg-name" {
  prefix    = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "cluster" {
  name     = random_pet.rg-name.id
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "cluster" {
  name                = "cluster-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name
}

resource "azurerm_subnet" "cluster" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.cluster.name
  virtual_network_name = azurerm_virtual_network.cluster.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "master_node" {
  name                = "master_node-public_ip"
  resource_group_name = azurerm_resource_group.cluster.name
  location            = azurerm_resource_group.cluster.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "worker_node" {
  name                = "worker_node-public_ip"
  resource_group_name = azurerm_resource_group.cluster.name
  location            = azurerm_resource_group.cluster.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "master_node" {
  name                = "master_node-nic"
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.cluster.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.master_private_ip_address
    public_ip_address_id          = azurerm_public_ip.master_node.id
  }
}

resource "azurerm_network_interface" "worker_node" {
  name                = "worker_node-nic"
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.cluster.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.worker_private_ip_address
    public_ip_address_id          = azurerm_public_ip.worker_node.id
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "master_node" {
  name                = "masterNetworkSecurityGroup"
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name

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

# Create Network Security Group and rule
resource "azurerm_network_security_group" "worker_node" {
  name                = "workerNetworkSecurityGroup"
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name

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

  security_rule {
    name                       = "k8s_services_port"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "30000-32767"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "master_node" {
  network_interface_id      = azurerm_network_interface.master_node.id
  network_security_group_id = azurerm_network_security_group.master_node.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "worker_node" {
  network_interface_id      = azurerm_network_interface.worker_node.id
  network_security_group_id = azurerm_network_security_group.worker_node.id
}

resource "azurerm_linux_virtual_machine" "master_node" {
  name                = "master-node"
  resource_group_name = azurerm_resource_group.cluster.name
  location            = azurerm_resource_group.cluster.location
  size                = "Standard_D2as_v4"
  admin_username      = "william"
  network_interface_ids = [
    azurerm_network_interface.master_node.id,
  ]

  admin_ssh_key {
    username   = "william"
    public_key = file("/azure/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "worker_node" {
  name                = "worker-node"
  resource_group_name = azurerm_resource_group.cluster.name
  location            = azurerm_resource_group.cluster.location
  size                = "Standard_D2as_v4"
  admin_username      = "william"
  network_interface_ids = [
    azurerm_network_interface.worker_node.id,
  ]

  admin_ssh_key {
    username   = "william"
    public_key = file("/azure/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
