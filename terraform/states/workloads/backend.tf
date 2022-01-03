
terraform {
  backend "local" {
    path          = "./workloads.tfstate"
    workspace_dir = "../../workspaces/workloads"
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
