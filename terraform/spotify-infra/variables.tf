variable "env" {
  description = "Execution environment"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "aws_profile" {
  description = "Local profile to execute the terraform"
  type        = string
}

variable "project_name" {
  description = "Project's name"
  type        = string
}
