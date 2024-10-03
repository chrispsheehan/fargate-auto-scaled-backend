resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = var.max_scaled_task_count
  min_capacity       = var.initial_task_count
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up" {
  name               = "${var.project_name}-scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 0
    }

    cooldown                = 60
    metric_aggregation_type = "Average"
  }
}

resource "aws_appautoscaling_policy" "scale_down" {
  name               = "${var.project_name}-scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_lower_bound = 0
    }

    cooldown                = 60
    metric_aggregation_type = "Average"
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.project_name}-scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = local.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.auto_scale_cool_down_period
  statistic           = "Average"
  threshold           = var.cpu_scale_up_threshold
  alarm_actions       = [aws_appautoscaling_policy.scale_up.arn]
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_name
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.project_name}-scale-down-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = local.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.auto_scale_cool_down_period
  statistic           = "Average"
  threshold           = var.cpu_scale_up_threshold
  alarm_actions       = [aws_appautoscaling_policy.scale_down.arn]
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_name
  }
}