# needed to fix
# * aws_lb.int-dmk-alb: Failure configuring LB attributes: InvalidConfigurationRequest: Access Denied for bucket: int-dmk-s3. Please check S3bucket permission
#        status code: 400, request id: 4a31aaa9-79ae-11e9-a878-01729055c4d2

# data "aws_iam_policy_document" "s3_lb_write_json" {
#     policy_id = "s3_lb_write"

#     statement = {
#         actions = ["s3:PutObject"]
#         resources = ["arn:aws:s3:::${local.lb_logs_bucket}/logs/*"]

#         principals = {
#             identifiers = ["${data.aws_elb_service_account.main.arn}"]
#             type = "AWS"
#         }
#     }
# }

# resource "aws_iam_policy" "s3_lb_write_policy" {
#   name   = "s3_lb_write_policy"
#   path   = "/"
#   policy = "${data.aws_iam_policy_document.s3_lb_write_json.json}"
# }


data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket_policy" "s3_lb_write_policy" {
  bucket = "${aws_s3_bucket.int-dmk-s3.id}"

  policy = <<POLICY
{
  "Id": "s3_lb_write_policy",
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "s3_lb_write_statement",
        "Action": [
            "s3:PutObject",
            "s3:*"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${local.lb_logs_bucket}/*",
        "Principal": {
            "AWS": [
                "${data.aws_elb_service_account.main.arn}",
                "${local.current_aws_account_arc}"
            ]
        }
    }
  ]
}
POLICY

}

