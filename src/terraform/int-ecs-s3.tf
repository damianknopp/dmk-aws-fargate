resource "aws_s3_bucket" "int-dmk-s3" {
  bucket = "${local.lb_logs_bucket}"
  acl    = "private"

  # This might be causing problems w/ logging from the load balancer
  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       kms_master_key_id = "${aws_kms_key.int-dmk-key.arn}"
  #       sse_algorithm     = "aws:kms"
  #     }
  #   }
  # }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # policy = "${aws_s3_bucket_policy.s3_lb_write_policy.arn}"
  tags = {
    environment = "integration"
  }
  # depends_on = ["aws_s3_bucket_policy.s3_lb_write_policy"]
}

# resource "aws_kms_key" "int-dmk-key" {
#   description             = "This key is used to encrypt bucket objects"
#   deletion_window_in_days = 10
#   tags = "${local.tags}"
# }
