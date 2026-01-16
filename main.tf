module "sns" {
  source             = "./modules/sns"
  notification_email = var.notification_email
}

module "s3" {
  source                = "./modules/s3"
  raw_bucket_name       = "invoice-processing-raw"
  processed_bucket_name = "invoice-processing-processed"
}

module "lambda" {
  source                = "./modules/lambda"
  project_name          = "invoice-processing"
  raw_bucket_arn        = module.s3.raw_bucket_arn
  processed_bucket_name = module.s3.processed_bucket_name
  sns_topic_arn         = module.sns.topic_arn
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_arn
  principal     = "s3.amazonaws.com"
  source_arn    = module.s3.raw_bucket_arn
}

resource "aws_s3_bucket_notification" "trigger" {
  bucket = module.s3.raw_bucket_name

  lambda_function {
    lambda_function_arn = module.lambda.lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
