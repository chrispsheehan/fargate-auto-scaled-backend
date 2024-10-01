output "security_group_id" {
  value = aws_security_group.lb_sg.id
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
