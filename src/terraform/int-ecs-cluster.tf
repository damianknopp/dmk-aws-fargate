resource "aws_ecs_cluster" "int-dmk-cluster" {
  name = "${local.cluster_name}"

  tags {
    environment = "integration"
    cluster = "${local.cluster_name}"
  }
}