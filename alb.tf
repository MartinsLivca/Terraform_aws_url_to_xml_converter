resource "aws_lb" "tf_load_balancer" {
  name               = "terraformtask"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.security_group.id]
  subnets            = [aws_subnet.main.id, aws_subnet.main2.id]
  enable_deletion_protection = false
  depends_on = [
    aws_security_group.security_group
    ]
}

resource "aws_lb_target_group" "tf_task_tg" {
  name        = "tftargetgroup"
  target_type = "lambda"
}

resource "aws_lambda_permission" "tf_task_perm" {
  function_name = aws_lambda_function.xml_file_downloader.arn
  source_arn    = aws_lb_target_group.tf_task_tg.arn
  principal     = "elasticloadbalancing.amazonaws.com"
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  depends_on = [
    aws_lb_target_group.tf_task_tg
    ]
}

resource "aws_lb_listener" "tf_lb_listener" {
  load_balancer_arn = aws_lb.tf_load_balancer.arn
  protocol          = "HTTP"
  port              = "80"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_task_tg.arn
  }
  depends_on = [
    aws_lb_target_group.tf_task_tg
    ]
}

resource "aws_lb_target_group_attachment" "lb_tg_attachment" {
  target_group_arn = aws_lb_target_group.tf_task_tg.arn
  target_id        = aws_lambda_function.xml_file_downloader.arn
  depends_on       = [
    aws_lambda_permission.tf_task_perm
    ]
  
}