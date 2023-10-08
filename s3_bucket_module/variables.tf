###############################################################################
# Variables - S3 Bucket
###############################################################################
variable "s3_bucket_name" {
  default     = null
  description = "Name of the bucket."
  type        = string
}

variable "app_name" {
  default     = "sftp_test"
  description = "Name of the App."
  type        = string
}
