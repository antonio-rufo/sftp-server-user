###############################################################################
# Variables - Environment
###############################################################################
variable "aws_account_id" {
  description = "(Required) The AWS Account ID."
}

variable "region" {
  description = "(Optional) Region where resources will be created."
  default     = "eu-west-1"
}

variable "environment" {
  description = "(Optional) The name of the environment, e.g. Production, Development, etc."
  default     = "Development"
}
