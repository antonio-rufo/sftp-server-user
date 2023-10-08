###############################################################################
# SFTP Server 1
###############################################################################
module "sftp_server_module" {
  source                 = "./transfer_sftp_server_module/"
  name                   = "sftp_test.sftp_server"
  iam_role_name          = "sftp-logging-role"
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [module.security_group_ec2.security_group_id]

  tags = {
    Environment = var.environment
  }
}

###############################################################################
# SFTP Users for SFTP Server 1
###############################################################################
### SAMPLE RESTRICTED USER
module "sftp_user_module" {
  source          = "./transfer_sftp_user_module/"
  sftp_server_id  = module.sftp_server_module.sftp_server_id
  ssh_public_keys = [file("./ssh_keys/user1_sshkey")]
  user_name       = "user1"
  role_name       = "user1-sftp-role"
  home_directory_bucket = {
    arn = module.s3_bucket.bucket_arn
    id  = module.s3_bucket.bucket_id
  }
  home_directory_key_prefix = "user1/"

  restricted = true
}

### SAMPLE ADMIN USER
module "sftp_user_module_admin" {
  source          = "./transfer_sftp_user_module/"
  sftp_server_id  = module.sftp_server_module.sftp_server_id
  ssh_public_keys = [file("./ssh_keys/user1_sshkey")]
  user_name       = "admin"
  role_name       = "admin-sftp-role"
  home_directory_bucket = {
    arn = module.s3_bucket.bucket_arn
    id  = module.s3_bucket.bucket_id
  }
  home_directory_key_prefix = ""
}

### SAMPLE USER WITH ADDITIONAL POLICY FROM USER1 - Just incase you want user2 to have access to User1 data
module "sftp_user_module_user2" {
  source          = "./transfer_sftp_user_module/"
  sftp_server_id  = module.sftp_server_module.sftp_server_id
  ssh_public_keys = [file("./ssh_keys/user1_sshkey")]
  user_name       = "user2"
  role_name       = "user2-sftp-role"
  home_directory_bucket = {
    arn = module.s3_bucket.bucket_arn
    id  = module.s3_bucket.bucket_id
  }
  home_directory_key_prefix = "user2/"
  iam_role_additional_policies = {
    additional = aws_iam_policy.additional.arn
  }
}

resource "aws_iam_policy" "additional" {
  name = "add-user1-permissions-to-user2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObjectACL",
          "s3:PutObject",
          "s3:GetObjectVersion",
          "s3:GetObjectACL",
          "s3:GetObject",
          "s3:DeleteObjectVersion",
          "s3:DeleteObject"
        ]
        Effect   = "Allow",
        Resource = "arn:aws:s3:::sftp-middle-office-antonio/user1/*"
      },
      {
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Effect   = "Allow",
        Resource = "arn:aws:s3:::sftp-middle-office-antonio"
      }
    ]
  })
}
