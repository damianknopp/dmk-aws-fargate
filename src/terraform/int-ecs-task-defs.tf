resource "aws_ecs_task_definition" "int-dmk-service" {
  family                = "int-dmk-service"
  container_definitions = "${file("task-definitions/service.json")}"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  # ClientException: host.sourcePath should not be set for volumes in Fargate.
  # volume {
  #   name      = "service-storage"
  #   host_path = "/ecs/service-storage"
  # }

  # ClientException: Fargate does not support task placement constraints.
  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-2b]"
  # }

  # ClientException: Fargate requires that 'cpu' be defined at the task level.
  # ie, not in the service.json file
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_AWSCLI_Fargate.html See, Step 2: Register a Task Definition
  # ClientException: No Fargate configuration exists for given values
  # ie, cpu and mem ratios are not valid
  # See, Valid Memory to CPU ratio https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu = 256
  memory = 512
  tags = "${local.tags}"
}