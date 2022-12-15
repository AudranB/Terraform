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
  access_key = "AKIAX665GLMWMEOIPB4H"
  secret_key = "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"
}