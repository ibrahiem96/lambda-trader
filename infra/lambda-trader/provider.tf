terraform {
  required_providers {
    klayers = {
      version = "~> 1.0.0"
      source  = "ldcorentin/klayer"
    }
  }
}

provider "aws" {
  region = "us-east-2" # Ohio
}