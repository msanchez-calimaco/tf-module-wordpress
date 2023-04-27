resource "aws_security_group" "controller-ssh" {
  name        = "Controller-SG"
  description = "allow SSH from my location"
  vpc_id      = module.vpc.vpc_id
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.ssh_location}"]
  }
 
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "${var.environment}-Controller-SG"
    Stage = "${var.environment}"
    Owner = "${var.your_name}"
  }
}
resource "aws_security_group" "web-sg" {
  name        = "Web-SG"
  description = "allow HTTP from Load Balancer, & SSH from controller"
  vpc_id      = module.vpc.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.controller-ssh.id}"]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
 
  }
 
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "${var.environment}-Web-SG"
    Stage = "${var.environment}"
    Owner = "${var.your_name}"
  }
}
resource "aws_security_group" "alb-sg" {
  name        = "ALB-SG"
  description = "allow Http, HTTPS"
  vpc_id      = module.vpc.vpc_id
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_location}"]
  }
 
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_location}"]
  }
 
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "${var.environment}-ALB-SG"
    Stage = "${var.environment}"
    Owner = "${var.your_name}"
  }
}
resource "aws_security_group" "efs-sg" {
  name   = "ingress-efs-sg"
  vpc_id = module.vpc.vpc_id
 
  // NFS
  ingress {
    security_groups = ["${aws_security_group.controller-ssh.id}", "${aws_security_group.web-sg.id}"]
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
  }
 
  egress {
    security_groups = ["${aws_security_group.controller-ssh.id}", "${aws_security_group.web-sg.id}"]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }
  tags = {
    Name  = "${var.environment}-MyEFS-SG"
    stage = "${var.environment}"
    Owner = "${var.your_name}"
  }
}
resource "aws_security_group" "MySQL-sg" {
  name        = "MySQL-SG"
  description = "allow SSH from Controller and MySQL from my IP and from web servers"
  vpc_id      = module.vpc.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.controller-ssh.id}"]
  }
 
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
 
    security_groups = ["${aws_security_group.web-sg.id}"]
  }
 
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "${var.environment}-MySQL-SG"
    Stage = "${var.environment}"
    Owner = "${var.your_name}"
  }
}