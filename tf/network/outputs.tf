output "api_invoke_url" {
  value = aws_apigatewayv2_stage.this.invoke_url
}

output "security_group_id" {
  value = aws_security_group.lb_sg.id
}

output "load_balancer_arn" {
  value = aws_lb.lb.arn
}

output "listener_arn" {
  value = aws_lb_listener.listener.arn
}

output "blue_target_group_arn" {
  value = aws_lb_target_group.tg_blue.arn
}

output "blue_target_group" {
  value = aws_lb_target_group.tg_blue.name
}

output "green_target_group" {
  value = aws_lb_target_group.tg_green.name
}

output "green_target_group_arn" {
  value = aws_lb_target_group.tg_green.arn
}