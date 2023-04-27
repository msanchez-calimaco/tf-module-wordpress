resource "random_pet" "app" {
  length    = 2
  separator = "-"
}
resource "aws_lb" "wordpress-alb" {
  name               = "main-app-${random_pet.app.id}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = ["${aws_security_group.alb-sg.id}"]
}
resource "aws_lb_listener" "wordpress-alb-listner" {
  load_balancer_arn = aws_lb.wordpress-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.wordpress-target.arn
      }
      stickiness {
        enabled  = true
        duration = 1
      }
    }
  }
}