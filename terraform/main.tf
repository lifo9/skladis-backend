terraform {
  backend "s3" {
    bucket = "terraform-filo-state-bucket"
    key    = "skladis/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "terraform-filo-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}
