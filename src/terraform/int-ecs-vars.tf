locals {
  cluster_name = "int-dmk-cluster"
  lb_logs_bucket = "int-dmk-s3"

  current_aws_account_arc = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/api-user"

  tags = {
    environment = "integration"
  }
}