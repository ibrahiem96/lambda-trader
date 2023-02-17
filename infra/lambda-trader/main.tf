module "alpacatrader_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.10.1"

  function_name = "alpacatrader"
  description   = "Lambda function to trade using Alpaca"
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  publish       = true
  timeout       = 30
  role_name     = "alpacatrader-lambda-${data.aws_region.current.name}"
  memory_size   = 512

  create_package         = false
  local_existing_package = local.alpacatrader_lambda_archive

  layers = [
    module.alpacatrader_lambda_boto3_layer.lambda_layer_arn,
    module.alpacatrader_lambda_alpaca_layer.lambda_layer_arn,
    data.klayers_package_latest_version.pandas.arn,
  ]

  # environment_variables = local.alpacatrader_environment_variables

  tags = {
    Name = "alpacatrader-lambda"
  }

  # allowed_triggers = {
  #   JobEvents = {
  #     principal = "*" # all accounts should be able to invoke this Lambda
  #   }
  # }

  attach_policy_json = true
  policy_json        = local.alpacatrader_policy_json

}

data "klayers_package_latest_version" "pandas" {
  name   = "pandas"
  region = "us-east-2"
}

data "archive_file" "alpacatrader_lambda_function" {
  type        = "zip"
  output_path = "/tmp/alpacatrader_lambda_function.zip"
  source_dir  = "./../../src"
}

resource "aws_lambda_alias" "alpacatrader_lambda_function_alias" {
  name             = "v1"
  function_name    = module.alpacatrader_lambda_function.lambda_function_name
  function_version = "$LATEST"
}

module "alpacatrader_lambda_boto3_layer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.10.1"

  layer_name               = "alpacatrader-boto3-layer"
  description              = "Layer for Lambda function to trade using Alpaca"
  compatible_runtimes      = ["python3.9"]
  compatible_architectures = ["x86_64"]

  create_layer            = true
  create_package          = false
  local_existing_package  = "./../../layers/boto3/boto3.zip"
  ignore_source_code_hash = true
}

module "alpacatrader_lambda_alpaca_layer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.10.1"

  layer_name               = "alpacatrader-alpaca-layer"
  description              = "Layer for Lambda function to trade using Alpaca"
  compatible_runtimes      = ["python3.9"]
  compatible_architectures = ["x86_64"]

  create_layer            = true
  create_package          = false
  local_existing_package  = "./../../layers/alpaca/alpaca.zip"
  ignore_source_code_hash = true
}
