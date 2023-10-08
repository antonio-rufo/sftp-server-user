###############################################################################
# Variables - SFTP Server
###############################################################################
variable "name" {
  description = "Name of the AWS Transfer Server"
  type        = string
}

variable "iam_role_name" {
  description = "Name of the AWS Transfer Server IAM Role used for logging to CloudWatch Logs"
  type        = string
  default     = "sftp-logging-role"
}

variable "iam_role_description" {
  description = "Description of the AWS Transfer Server IAM Role used for logging to CloudWatch Logs"
  type        = string
  default     = "IAM Role used by AWS Transfer Server to log to Cloudwatch"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}

variable "security_policy_name" {
  type        = string
  description = "Specifies the name of the security policy that is attached to the server."
  default     = "TransferSecurityPolicy-2020-06"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID that the AWS Transfer Server will be deployed to"
  default     = null
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "A list of security groups IDs that are available to attach to your server's endpoint. If no security groups are specified, the VPC's default security groups are automatically assigned to your endpoint. This property can only be used when endpoint_type is set to VPC."
  default     = []
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs that are required to host your SFTP server endpoint in your VPC. This property can only be used when endpoint_type is set to VPC."
  default     = []
}
