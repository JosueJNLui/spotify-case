variable "env" {
  description = "Execution environment"
  type        = string
}

variable "scheduler_name" {
  description = "Scheduler name for EventBridge"
  type        = string
}

variable "group_name" {
  description = "Scheduler's group name"
  type        = string
}

variable "cron_rule" {
  description = "Cron expression used by Scheduler"
  type        = string
}

variable "schedule_expression_timezone" {
  description = "The timezone used for specifying the schedule expression in AWS EventBridge"
  type        = string
  default = "America/Sao_Paulo"
}

variable "target_arn" {
  description = "Target resource arn used by Scheduler"
  type        = string
}

variable "target_role_arn" {
  description = "Target role arn used by Scheduler"
  type        = string
}