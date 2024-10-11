locals {
  evaluation_periods = var.auto_scale_cool_down_period <= 60 ? 1 : var.auto_scale_cool_down_period / 60
}
