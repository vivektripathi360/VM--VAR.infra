terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "4.42.0"
    }
  }
}


provider "azurerm" {
    features {}
    subscription_id =  "e59b3be3-2cd8-493e-a182-a6b8da13eccc"

}
