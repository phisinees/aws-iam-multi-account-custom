terraform {
  backend "remote" {
    organization = "pomelofashion"

    workspaces {
      name = "iam-training-global"
    }
  }
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.22.0"
    }
    # vault = {
    #   source  = "hashicorp/vault"
    #   version = "2.17.0"
    # }
  }
}

# provider "vault" {
#   address = "https://vault.pmlo.co"

#   auth_login {
#     path = "auth/approle/login"

#     parameters = {
#       role_id   = var.approle_role_id
#       secret_id = var.approle_secret_id
#     }
#   }
# }

provider "aws" {
  region = "ap-southeast-1"
  alias  = "training"

  allowed_account_ids = [842779164587]

  assume_role {
    role_arn = "arn:aws:iam::842779164587:role/AdminUser"
  }

  # access_key = data.vault_aws_access_credentials.creds.access_key
  # secret_key = data.vault_aws_access_credentials.creds.secret_key
  # token      = data.vault_aws_access_credentials.creds.security_token
}
