terraform {
  required_version = "1.2.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.17.1"
    }
  }
}
provider "aws" {
  region = "us-east-1"
  access_key = "my_access_key"
  secret_key = "my_secret_key"
}