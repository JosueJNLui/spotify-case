variable "identifier" {
  description = "The name or identifier for the RDS instance."
  type        = string
}

variable "allocated_storage" {
  description = "The amount of storage (in gibibytes) to allocate for the RDS instance."
  type        = number
  default     = 10
}

variable "engine" {
  description = "The database engine to use for the RDS instance."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The database engine version to use for the RDS instance."
  type        = string
  default     = "14"
}

variable "instance_class" {
  description = "The instance class of the RDS instance, specifying its compute and memory capacity."
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of database to create when the DB instance is created."
  type        = string
}

variable "username" {
  description = "The username for the master user of the RDS instance."
  type        = string
}

variable "skip_final_snapshot" {
  description = "Whether to skip the creation of a final DB snapshot when the RDS instance is deleted."
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "Path to the requirements file"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "Available CIDR blocks for public subnets"
  type        = string
  default = "10.0.1.0/24"
}
