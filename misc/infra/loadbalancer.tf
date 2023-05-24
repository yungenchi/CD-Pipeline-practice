# Create a target group
resource "aws_lb_target_group" "a2" {
vpc_id = data.aws_vpc.default.id
  name     = "a2-front"
  port     = 80
  protocol = "HTTP"
}


# Attach the target group to the AWS instances
resource "aws_lb_target_group_attachment" "attach-app" {
  for_each = local.vms_app
  target_group_arn = aws_lb_target_group.a2.arn
  target_id        = aws_instance.apps[each.key].id
  port             = 80
}


# Create the load balancer
resource "aws_lb" "a2" {
    name               = "a2-front"
    internal           = false
    load_balancer_type = "application"
    subnets = [for subnet in data.aws_subnets.private.ids : subnet ]
    security_groups    = [aws_security_group.vms.id]
}

data "aws_subnets" "private" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

# Create a listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.a2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.a2.arn
  }
}

# default vpc
data "aws_vpc" "default" {
    default = true
}


output "load_balancer_dns_name" {
  value = aws_lb.a2.dns_name
}