terraform {
  backend "s3" {
    bucket = "exercise3bucket"
    key    = "state/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

