variable "region" {
    default = "us-east-1"
}

provider "aws" {
  region = "${var.region}"
}

terraform {
    backend "s3" {
        encrypt = true
        region = "us-east-1"
        bucket = "dknopp-test-bucket"
        key = "int-dmk-terraform-state.tf"
    }
}