output "Controller-sg_id" {
  value       = [aws_security_group.controller-ssh.id]
}
output "vpc_id" {
  description = "Output VPC ID"
  value       = module.vpc.vpc_id
}
output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}
output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}
output "lb_dns_name" {
  value = aws_lb.wordpress-alb.dns_name
}
output "Auto_Scaling_Group_Name" {
  value = aws_autoscaling_group.wordpress_asg.name
}
output "aws_security_group-alb_sg-id" {
  value = "${aws_security_group.alb-sg.id}"
}
output "aws_security_group_MySQL-sg_id" {
  value = "${aws_security_group.MySQL-sg.id}"
}

output "aws_security_group_efs-sg_id" {
  value = "${aws_security_group.efs-sg.id}"
}

output "intra_subnets0" {
  value = module.vpc.intra_subnets[0]
}

output "intra_subnets1" {
  value = module.vpc.intra_subnets[1]
}

output "aws_security_group_web-sg_id" {
  value = "${aws_security_group.web-sg.id}"
}

