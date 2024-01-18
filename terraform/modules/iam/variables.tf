variable "project_name" {
  description = "Project's name"
  type        = string
}

variable "env" {
  description = "Execution environment"
  type        = string
}

variable "iam_policy_document" {
  description = "IAM policy document declaring the inline policies for a role"
  type        = string
}

variable "iam_policy_assume_role" {
  description = "IAM policy document to assume the role"
  type        = string
}