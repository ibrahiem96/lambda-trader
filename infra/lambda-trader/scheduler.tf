resource "aws_cloudwatch_event_rule" "schedule" {
    name = "alpacatrader-lambda-schedule"
    description = "Schedule for Lambda Function"
    schedule_expression = local.schedule
}

resource "aws_cloudwatch_event_target" "schedule_lambda" {
    rule = aws_cloudwatch_event_rule.schedule.name
    target_id = "alpacatrader"
    arn = module.alpacatrader_lambda_function.lambda_function_arn
}

resource "aws_lambda_permission" "allow_events_bridge_to_run_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = module.alpacatrader_lambda_function.lambda_function_name
    principal = "events.amazonaws.com"
}