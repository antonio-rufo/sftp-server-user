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
# CloudWatch Log Group
###############################################################################
resource "aws_cloudwatch_log_group" "transfer" {
  name = var.log_group_name

  tags = var.tags
}

data "aws_iam_policy_document" "transfer_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_transfer" {
  name_prefix         = "iam_for_transfer_"
  assume_role_policy  = data.aws_iam_policy_document.transfer_assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSTransferLoggingAccess"]
}

###############################################################################
# SFTP Transfer Server
###############################################################################
resource "aws_transfer_server" "main" {
  identity_provider_type = "SERVICE_MANAGED"
  protocols              = ["SFTP"]
  endpoint_type          = local.is_vpc ? "VPC" : "PUBLIC"
  security_policy_name   = var.security_policy_name
  logging_role           = aws_iam_role.iam_for_transfer.arn

  dynamic "endpoint_details" {
    for_each = local.is_vpc ? [1] : []

    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.vpc_security_group_ids
      vpc_id             = var.vpc_id
    }
  }

  structured_log_destinations = [
    "${aws_cloudwatch_log_group.transfer.arn}:*"
  ]

  tags = merge({
    Name = var.name
  }, var.tags)
}
