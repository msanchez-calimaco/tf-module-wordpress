#--------- Get Amazon Linux 2 AMI image  -------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
# ---------  Create Launch Template ----------------------------
resource "aws_launch_template" "wordpress" {
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
  user_data              = base64encode("${data.template_file.bootstrap.rendered}")
  depends_on             = [aws_efs_file_system.my_efs, aws_instance.mariadb]
  lifecycle { create_before_destroy = true }
  #monitoring             = true
}
 
# ------------ Create  Auto Scaling Group ----------------------
resource "aws_autoscaling_group" "wordpress_asg" {
  launch_template {
    name    = aws_launch_template.wordpress.name
    version = aws_launch_template.wordpress.latest_version
  }
  vpc_zone_identifier = module.vpc.private_subnets
  min_size            = 2
  max_size            = 6
  desired_capacity    = 2
  tag {
    key                 = "Name"
    value               = "${var.environment}-Wordpress_ASG"
    propagate_at_launch = true
  }
  depends_on            = [aws_instance.mariadb]
}
data "template_file" "bootstrap" {
  template = file("bootstrap_wordpress.tpl")
  vars = {
    efs_id   = "${aws_efs_file_system.my_efs.id}"
    dbhost   = "${aws_instance.mariadb.private_ip}"
    user     = var.user
    password = var.password
    dbname   = var.dbname
    domain_name = var.domain_name
  }
}

# ------------ Create  Auto Scaling policies ----------------------
resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_up.arn ]
}

resource "aws_autoscaling_policy" "web_policy_down" {
  name = "web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.web_policy_down.arn ]
}