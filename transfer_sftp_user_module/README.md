Creates a user for an AWS Transfer for SFTP endpoint.

Creates the following resources:

* AWS Transfer user
* IAM policy for the user to access S3.
* SSH Keys attached to the Transfer user.

## Usage

```hcl
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
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_actions | A list of allowed actions for objects in the backend bucket. | `list(string)` | <pre>[<br>  "s3:GetObject",<br>  "s3:GetObjectACL",<br>  "s3:GetObjectVersion",<br>  "s3:PutObject",<br>  "s3:PutObjectACL",<br>  "s3:DeleteObject",<br>  "s3:DeleteObjectVersion"<br>]</pre> | no |
| home\_directory\_bucket | The S3 Bucket to use as the home directory | <pre>object({<br>    arn = string<br>    id  = string<br>  })</pre> | n/a | yes |
| home\_directory\_key\_prefix | The home directory key prefix | `string` | `""` | no |
| role\_arn | The name of the IAM role for the SFTP user. Either `role_name` or `role_arn` must be provided, not both. | `string` | `""` | no |
| role\_name | The name of the IAM role for the SFTP user. Either `role_name` or `role_arn` must be provided, not both. | `string` | `""` | no |
| sftp\_server\_id | Server ID of the AWS Transfer Server (aka SFTP Server) | `string` | n/a | yes |
| ssh\_public\_keys | Public SSH key for the user.  If list is empty, then no SSH Keys are setup to authenticate as the user. | `list(string)` | `[]` | no |
| tags | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |
| create\_role | Whether to create a role | `bool` | true | no |
| user\_name | The name of the user | `string` | n/a | yes |
| iam\_role\_additional\_policies | Additional policies to be added to the IAM role | `map(string)` | {} | no |

## Outputs

No outputs.
