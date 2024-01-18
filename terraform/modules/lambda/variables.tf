variable "function_name" {
  description = "Lambda function's name"
  type        = string
}

variable "handler" {
  description = "Lambda function's entrypoint function"
  type        = string
  default     = "lambda_handler.lambda_handler"
}

variable "layers" {
  description = "List containing the layers for the Lambda function"
  type        = list(string)
  default     = []
}

variable "role" {
  description = "IAM role arn to be used for Lambda function"
  type        = string
}

variable "runtime" {
  description = "Runtime for Lambda function"
  type        = string
  default     = "python3.10"
}

variable "timeout" {
  description = "Timeout for Lambda function"
  type        = number
  default     = 300
}

variable "memory_size" {
  description = "Memory size for Lambda function"
  type        = number
  default     = 128
}

variable "filename" {
  description = "Path to the deployment package"
  type        = string
}

variable "source_code_hash" {
  description = "Hash value derived from the contents of the deployment package"
  type        = string
}

variable "variables" {
  description = "Environment variables for Lambda function"
  type        = map(string)
  default     = {}
}
