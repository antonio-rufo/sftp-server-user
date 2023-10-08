###############################################################################
# Outputs - S3 Bucket
###############################################################################
output "bucket" {
  description = "The SFTP bucket."
  value       = aws_s3_bucket.sftp_bucket.bucket
}

output "bucket_id" {
  description = "Name of the S3 bucket."
  value       = aws_s3_bucket.sftp_bucket.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket."
  value       = aws_s3_bucket.sftp_bucket.arn
}
