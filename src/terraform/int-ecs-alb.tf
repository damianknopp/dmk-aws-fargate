resource "aws_lb" "int-dmk-alb" {
  name               = "int-dmk-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.int-dmk-allow-all-sg.id}"]
  subnets            = ["${aws_subnet.int-dmk-subnet-1.id}", "${aws_subnet.int-dmk-subnet-2.id}"]

  enable_deletion_protection = false

  access_logs {
    bucket  = "${aws_s3_bucket.int-dmk-s3.bucket}"
    prefix  = "int-dmk-alb"
    enabled = true
  }

  tags = "${local.tags}"
  depends_on = ["aws_vpc.int-dmk-vpc", "aws_internet_gateway.int-dmk-internet-gw"]
}

resource "aws_lb_target_group" "int-dmk-alb-ip-target-group" {
  name        = "int-dmk-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_vpc.int-dmk-vpc.id}"
  tags = "${local.tags}"
  depends_on = ["aws_lb.int-dmk-alb"]
}

resource "aws_lb_listener" "int-dmk-alb-listener" {
  load_balancer_arn = "${aws_lb.int-dmk-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.int-dmk-alb-ip-target-group.arn}"
  }
  depends_on = ["aws_lb.int-dmk-alb"]
}
