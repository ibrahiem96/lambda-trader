module "terraform_state_backend" {
  source = "cloudposse/tfstate-backend/aws"
  version = "0.38.1"

  namespace  = "proj"
  stage      = "lambda-trader"
  name       = "ibrahiem"
  attributes = ["state"]

  terraform_backend_config_file_path = "../lambda-trader"
  terraform_backend_config_file_name = "state.tf"
  force_destroy                      = true
}