resource "aws_lb_target_group" "wordpress-target" {
  name     = "wordpress-${random_pet.app.id}-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}
# ----- Create a new ALB Target Group attachment. ------
resource "aws_autoscaling_attachment" "asg_attachment_website" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.id
  lb_target_group_arn    = aws_lb_target_group.wordpress-target.arn
}