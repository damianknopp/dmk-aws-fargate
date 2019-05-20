# Retrieve the AZ where we want to create network resources
# This must be in the region selected on the AWS provider.
data "aws_availability_zone" "int-dmk-az-1" {
  name = "us-east-1a"
}

data "aws_availability_zone" "int-dmk-az-2" {
  name = "us-east-1c"
}

resource "aws_vpc" "int-dmk-vpc" {
  cidr_block = "10.10.0.0/16"
  tags = "${local.tags}"
}

resource "aws_internet_gateway" "int-dmk-internet-gw" {
  vpc_id = "${aws_vpc.int-dmk-vpc.id}"
  tags = "${local.tags}"
  depends_on = ["aws_vpc.int-dmk-vpc"]
}

resource "aws_route_table" "int-dmk-rt" {
  vpc_id = "${aws_vpc.int-dmk-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.int-dmk-internet-gw.id}"
  }

  # route {
  #   cidr_block = "10.10.0.0/16"
  #   gateway_id = "${aws_internet_gateway.int-dmk-internet-gw.id}"
  # }

  # route {
  #   cidr_block = "10.10.1.0/24"
  #   gateway_id = "${aws_internet_gateway.int-dmk-internet-gw.id}"
  # }

  # route {
  #   cidr_block = "10.10.2.0/24"
  #   gateway_id = "${aws_internet_gateway.int-dmk-internet-gw.id}"
  # }

  tags = "${local.tags}"
  depends_on = ["aws_vpc.int-dmk-vpc", "aws_route_table.int-dmk-rt"]
}

resource "aws_main_route_table_association" "int-dmk-rt-assoc" {
  vpc_id         = "${aws_vpc.int-dmk-vpc.id}"
  route_table_id = "${aws_route_table.int-dmk-rt.id}"
}


resource "aws_subnet" "int-dmk-subnet-1" {
  vpc_id     = "${aws_vpc.int-dmk-vpc.id}"
  cidr_block = "10.10.1.0/24"
  availability_zone = "${data.aws_availability_zone.int-dmk-az-1.name}"
  tags = "${local.tags}"
  depends_on = ["aws_vpc.int-dmk-vpc"]
}

resource "aws_subnet" "int-dmk-subnet-2" {
  vpc_id     = "${aws_vpc.int-dmk-vpc.id}"
  cidr_block = "10.10.2.0/24"
  availability_zone = "${data.aws_availability_zone.int-dmk-az-2.name}"
  tags = "${local.tags}"
  depends_on = ["aws_vpc.int-dmk-vpc"]
}

resource "aws_security_group" "int-dmk-allow-all-sg" {
  name        = "int-dmk-allow-all-sg"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.int-dmk-vpc.id}"

  # ingress {
  #   # TLS (change to whatever ports you need)
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "-1"
  #   # Please restrict your ingress to only necessary IPs and ports.
  #   # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${local.tags}"
}