terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.45"
    }
  }
}
provider "aws" {
  region     = "eu-west-3"
  access_key = "${file("key/access_key")}"
  secret_key = "${file("key/secret_key")}"
}