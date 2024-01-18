variable "requirements_path" {
  description = "Path to the requirements file"
  type        = string
}

variable "layer_path" {
  description = "Path to the directory where the layer artifacts will be stored"
  type        = string
}

variable "requirements_name" {
  description = "Name of the requirements file"
  type        = string
}

variable "layer_name" {
  description = "Name of the layer"
  type        = string
}

variable "layer_zip_name" {
  description = "Name of the layer zip file"
  type        = string
}

variable "compatible_runtimes" {
  description = "List of compatible runtime versions for the layer"
  type        = string
  default     = "python3.10"
}

variable "aws_account_id" {
  description = "Amazon account ID"
  type        = string
}
