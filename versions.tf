terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.24.1, < 4.0"
    }
  }
  required_version = ">= 1.0, < 2.0"
}
