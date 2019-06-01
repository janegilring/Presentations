terraform {
  backend "azurerm" {
    storage_account_name = "terraformstate"
    container_name       = "tfstate"
    key                  = "infrastructure-rg.terraform.tfstate"
    //access_key           = "1234567j3dluhNg/rHk0B5z+usoda9aEnvM9obANddY+D5CCA=="  Can also be set using the ARM_ACCESS_KEY environment variable.
  }
}

# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.27.1"
}

resource "azurerm_automation_account" aa {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name

  sku {
    name = "Basic"
  }

     tags = {
        CostCenter  = "1234"
        Department  = "123"
        Environment = "Production"
        Source = "terraform"
    }
  
}