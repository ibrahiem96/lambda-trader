terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "us-east-2"
    bucket         = "proj-lambda-trader-ibrahiem-state"
    key            = "terraform.tfstate"
    dynamodb_table = "proj-lambda-trader-ibrahiem-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
