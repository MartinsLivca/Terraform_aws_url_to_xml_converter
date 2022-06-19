resource "aws_iam_role" "tf_lambda_iam" {
  name = "tf_lambda_iam"
  assume_role_policy = file("policies/assume_role_policy_iam.json")
  
}
resource "aws_iam_role_policy" "tf_lambda_iam_policy" {
  name = "tf_lambda_iam_policy"
  role = aws_iam_role.tf_lambda_iam.id
  policy = file("policies/ec2_policy.json")
  depends_on = [
    aws_iam_role.tf_lambda_iam
    ]
}

resource "aws_iam_role_policy" "vpc_role_policy" {
  name = "vpc_role_policy"
  role = aws_iam_role.tf_lambda_iam.id
  policy = file("policies/vpc_role_policy.json")
  depends_on = [
    aws_iam_role.tf_lambda_iam
    ]
}

resource "aws_iam_role_policy" "s3_lambda_policy" {
  name = "s3_lambda_policy"
  role = aws_iam_role.tf_lambda_iam.id
  policy = file("policies/s3_lambda_poilcy.json")
  depends_on = [
    aws_iam_role.tf_lambda_iam
    ]
}
resource "aws_iam_role" "tf_s3_iam_role" {
  name = "tf_s3_iam_role"

  assume_role_policy = file("policies/assume_role_policy_s3.json")
}

resource "aws_iam_role_policy" "tf_s3_role_policy" {
  name = "tf_s3_role_policy"
  role = aws_iam_role.tf_s3_iam_role.id
  policy = file("policies/s3_iam_policy.json")
  depends_on = [
    aws_iam_role.tf_s3_iam_role
    ]
}

resource "aws_iam_role_policy" "tf_s3_role_policy2" {
  name = "tf_s3_role_policy2"
  role = aws_iam_role.tf_lambda_iam.id 
  policy = file("policies/s3_lambda_poilcy.json")
  depends_on = [
    aws_iam_role.tf_lambda_iam
    ]
}

data "aws_elb_service_account" "main" {}