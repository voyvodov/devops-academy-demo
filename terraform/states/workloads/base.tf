

data "terraform_remote_state" "base" {
  backend = "local"
  config = {
    path = "../../workspaces/base/${terraform.workspace}/terraform.tfstate"
  }
}


