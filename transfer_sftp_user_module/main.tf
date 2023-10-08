###############################################################################
# SFTP User
###############################################################################
data "aws_iam_policy_document" "assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
  }
}

###############################################################################
# SFTP User IAM Role
###############################################################################
resource "aws_iam_role" "main" {
  count = var.role_arn == "" ? 1 : 0

  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = { for k, v in var.iam_role_additional_policies : k => v if var.create_role }

  policy_arn = each.value
  role       = aws_iam_role.main[0].name
}

data "aws_iam_policy_document" "role_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      var.home_directory_bucket.arn
    ]
  }
  statement {
    effect  = "Allow"
    actions = var.allowed_actions
    resources = [
      format("%s/%s*", var.home_directory_bucket.arn, var.home_directory_key_prefix)
    ]
  }
}

###############################################################################
# SFTP User IAM Additional Policy
###############################################################################
resource "aws_iam_role_policy" "main" {
  count = var.role_arn == "" ? 1 : 0

  name   = format("%s-policy", aws_iam_role.main[0].name)
  role   = aws_iam_role.main[0].name
  policy = data.aws_iam_policy_document.role_policy_doc.json
}

###############################################################################
# SFTP Transfer User (NON-RESTRICTED)
###############################################################################
resource "aws_transfer_user" "main" {
  count = var.restricted ? 0 : 1

  server_id      = var.sftp_server_id
  user_name      = var.user_name
  role           = var.role_arn == "" ? aws_iam_role.main[0].arn : var.role_arn
  home_directory = format("/%s/%s", var.home_directory_bucket.id, var.home_directory_key_prefix)

  tags = merge(
    var.tags,
    {
      "Automation" = "Terraform"
    },
  )
}

###############################################################################
# SFTP Transfer User (RESTRICTED)
###############################################################################
resource "aws_transfer_user" "main_restricted" {
  count = var.restricted ? 1 : 0

  server_id = var.sftp_server_id
  user_name = var.user_name
  role      = var.role_arn == "" ? aws_iam_role.main[0].arn : var.role_arn

  home_directory_type = "LOGICAL"

  home_directory_mappings {
    entry  = "/"
    target = "/${var.home_directory_bucket.id}/${var.user_name}"
  }

  tags = merge(
    var.tags,
    {
      "Automation" = "Terraform"
    },
  )
}

###############################################################################
# SFTP Transfer User SSH Key
###############################################################################
resource "aws_transfer_ssh_key" "main" {
  count = length(var.ssh_public_keys)

  server_id = var.sftp_server_id
  user_name = concat(aws_transfer_user.main.*.user_name, aws_transfer_user.main_restricted.*.user_name)[0]
  body      = var.ssh_public_keys[count.index]
}
