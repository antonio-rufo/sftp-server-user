###############################################################################
# SFTP Server
###############################################################################
locals {
  is_vpc = var.vpc_id != null
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

###############################################################################
# SFTP Transfer IAM Role
###############################################################################
resource "aws_iam_role" "main" {
  name               = var.iam_role_name
  description        = var.iam_role_description
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags               = var.tags
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    actions = [
      "logs:DescribeLogStreams",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      format("arn:aws:logs:%s:%s:*", data.aws_region.current.name, data.aws_caller_identity.current.account_id)
    ]
  }
}

resource "aws_iam_role_policy" "main" {
  name   = var.iam_role_name
  role   = aws_iam_role.main.name
  policy = data.aws_iam_policy_document.role_policy.json
}

###############################################################################
# SFTP Transfer Server
###############################################################################
resource "aws_transfer_server" "main" {
  identity_provider_type = "SERVICE_MANAGED"
  protocols              = ["SFTP"]
  endpoint_type          = local.is_vpc ? "VPC" : "PUBLIC"
  security_policy_name   = var.security_policy_name
  logging_role           = aws_iam_role.main.arn

  dynamic "endpoint_details" {
    for_each = local.is_vpc ? [1] : []

    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.vpc_security_group_ids
      vpc_id             = var.vpc_id
    }
  }

  tags = merge({
    Name = var.name
  }, var.tags)
}
