data "aws_caller_identity" "current" {}

output "caller_account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "caller_arn" {
  value = "${data.aws_caller_identity.current.arn}"
}

output "caller_user" {
  value = "${data.aws_caller_identity.current.user_id}"
}

output "aws_az_1" {
  value = "${data.aws_availability_zone.int-dmk-az-1.name}"
}

output "aws_az_2" {
  value = "${data.aws_availability_zone.int-dmk-az-2.name}"
}
