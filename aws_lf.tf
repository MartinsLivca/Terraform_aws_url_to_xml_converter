
resource "aws_lambda_function" "xml_file_downloader" {
  filename      = "lambda_function.zip"
  function_name = "xml_file_downloader"
  role          = aws_iam_role.tf_lambda_iam.arn
  handler       = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.9"
  timeout          = "40"
  memory_size      = 256
  publish          = true
  depends_on = [
    aws_iam_role.tf_lambda_iam
    ]
}

