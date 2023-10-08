Creates an AWS Transfer for SFTP server.

Creates the following resources:

* AWS Transfer for SFTP Server.
* IAM role for logging.

## Usage

```hcl
module "sftp_server_module" {
  source                 = "./transfer_sftp_server_module/"
  name                   = "sftp_test.sftp_server"
  iam_role_name          = "sftp-logging-role"
  vpc_id                 = module.base_network.vpc_id
  subnet_ids             = module.base_network.private_subnets
  vpc_security_group_ids = [module.security_group_ec2.security_group_id]

  tags = {
    Environment = var.environment
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| iam\_role\_description | Description of the AWS Transfer Server IAM Role used for logging to CloudWatch Logs | `string` | `"IAM Role used by AWS Transfer Server to log to Cloudwatch"` | no |
| iam\_role\_name | Name of the AWS Transfer Server IAM Role used for logging to CloudWatch Logs | `string` | `"sftp-logging-role"` | no |
| name | Name of the AWS Transfer Server | `string` | n/a | yes |
| protocols | Specifies the file transfer protocol or protocols over which your file transfer protocol client can connect to your server's endpoint. | `list(string)` | ```[ "SFTP" ]``` | no |
| security\_policy\_name | Specifies the name of the security policy that is attached to the server. | `string` | `"TransferSecurityPolicy-2020-06"` | no |
| tags | Additional tags | `map(string)` | `{}` | no |
| vpc_id | VPC ID that the AWS Transfer Server will be deployed to. | `string` | `null` | yes |
| subnet_ids | A list of subnet IDs that are required to host your SFTP server endpoint in your VPC. | `list(string)` | `[]` | yes |
| vpc_security_group_ids | A list of security groups IDs that are available to attach to your server's endpoint. | `list(string)` | `[]` | yes |

## Outputs

| Name | Description |
|------|-------------|
| sftp\_server\_endpoint | The endpoint of the Transfer Server |
| sftp\_server\_id | Server ID of the AWS Transfer Server (aka SFTP Server) |
