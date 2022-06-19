resource "aws_s3_bucket" "tf_task" {
  bucket = "lambdataskbucketml"
    depends_on = [
    aws_lambda_function.xml_file_downloader
    ]
}

resource "aws_s3_bucket_acl" "tf_bucket_acl" {
  bucket = aws_s3_bucket.tf_task.id
  acl    = "private"
}

