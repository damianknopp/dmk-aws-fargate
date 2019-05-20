resource "aws_ecs_service" "int-dmk-nginx-service" {
  name            = "nginx"
  cluster         = "${aws_ecs_cluster.int-dmk-cluster.id}"
  task_definition = "${aws_ecs_task_definition.int-dmk-service.arn}"
  desired_count   = 1
  #   iam_role        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  #   iam_role        = "${aws_iam_role.foo.arn}"
  #   depends_on      = ["aws_iam_role_policy.foo"]

  launch_type = "FARGATE"

# InvalidParameterException: Placement strategies are not supported with FARGATE launch type
#   ordered_placement_strategy {
#     type  = "binpack"
#     field = "cpu"
#   }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.int-dmk-alb-ip-target-group.arn}"
    container_name   = "int-dmk-nginx"
    container_port   = 80
  }

#  InvalidParameterException: Placement constraints are not supported with FARGATE launch type.
#   placement_constraints {
#     type       = "memberOf"
#     expression = "attribute:ecs.availability-zone in [${data.aws_availability_zone.int-dmk-az-1.name}, ${data.aws_availability_zone.int-dmk-az-2.name}]"
#   }

  network_configuration {
    subnets = ["${aws_subnet.int-dmk-subnet-1.id}", "${aws_subnet.int-dmk-subnet-2.id}"]
    security_groups = ["${aws_security_group.int-dmk-allow-all-sg.id}"]
    # CannotPullContainer, unless there is a public IP or a route setup
    # https://github.com/aws/amazon-ecs-agent/issues/1128
    assign_public_ip = true
  }

  # InvalidParameterException: The new ARN and resource ID format must be enabled to add tags to the service. Opt in to the new format and try again.
  #   tags = "${local.tags}"
  depends_on = ["aws_lb.int-dmk-alb", "aws_lb_target_group.int-dmk-alb-ip-target-group", "aws_vpc.int-dmk-vpc", "aws_internet_gateway.int-dmk-internet-gw"]
}