terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }
  backend "local" {}
}

module "aws_vpc" {
  source = "./module/aws/vpc"
  environment = var.environment
}

module "azure_network" {
  source = "./module/azure/network"
  environment = var.environment
  subscription_id = var.azure_subscription_id
}

module "aws_kubernetes" {
  source = "./module/aws/kubernetes"
  environment = var.environment
}

module "azure_kubernetes" {
  source = "./module/azure/kubernetes"
  environment = var.environment
  subscription_id = var.azure_subscription_id
}
