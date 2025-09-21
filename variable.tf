variable "infra_config"{
sensitive = true
  default = {
    rg_name = "testrg"
    rg_location = "westus"
    vnet_name = "vnet1"
    address_space = ["10.0.0.0/16"]
    subnet_name = "subnet1"
    address_prefixes = ["10.0.0.0/24"]
    nic_name = "vm1"
    ip_name = "vm1-ip"
    private_ip_address_allocation = "Dynamic"
    nsg_name = "vm1-nsg"
    vm_name = "vm1"
    vm_size = "Standard_F2"
    admin_username = "vivek"
    admin_password = "vivek@12345678"
    pip_name = "vm1-ip"
}
}

