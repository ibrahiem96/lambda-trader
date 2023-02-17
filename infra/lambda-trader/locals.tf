locals {
  # every day at 10:15AM UTC
  schedule = "cron(15 10 * * ? *)"

  alpacatrader_lambda_archive = data.archive_file.alpacatrader_lambda_function.output_path

  alpacatrader_environment_variables = {

  }

  alpacatrader_policy_json = <<-EOT
      {
          "Version": "2012-10-17",
          "Statement": [
              {
                  "Effect": "Allow",
                  "Action": [
                      "ssm:GetParameter*",
                      "ssm:Describe*"
                  ],
                  "Resource": [
                    "arn:aws:ssm:us-east-2:390685899791:parameter/alpaca*"
                  ]
              },
              {
                  "Effect": "Allow",
                  "Action": [
                      "kms:Decrypt"
                  ],
                  "Resource": [
                    "arn:aws:kms:us-east-2:390685899791:key/372ae77a-b765-4cbd-8d5d-f18a47146a21"
                  ]
              }
          ]
      }
    EOT
}