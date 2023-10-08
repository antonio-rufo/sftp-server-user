###############################################################################
# S3 Bucket
###############################################################################
resource "aws_s3_bucket" "sftp_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "${var.app_name}.aws_s3_bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.sftp_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "sftp_bucket_versioning" {
  bucket = aws_s3_bucket.sftp_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "sftp_bucket_acl" {
  bucket = aws_s3_bucket.sftp_bucket.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}
