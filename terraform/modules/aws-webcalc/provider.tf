terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.44" # Update to match the locked version
    }
    # docker = {
    #   source  = "kreuzwerker/docker"
    #   version = ">= 2.0, < 3.0"  # Specify a version constraint
    # }
  }
}
