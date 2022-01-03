
terraform {
  backend "local" {
    path          = "./base.tfstate"
    workspace_dir = "../../workspaces/base"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

terraform {
  required_providers {
    ansible = {
      source  = "nbering/ansible"
      version = "1.0.4"
    }
  }
}
