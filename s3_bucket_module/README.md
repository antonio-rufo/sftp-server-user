# AWS S3 Bucket Instance Terraform module

Terraform module which creates an S3 bucket on AWS.

## Usage

### Single S3 Bucket

```hcl
module "s3_bucket" {
  source = "./s3_bucket_module/"

  s3_bucket_name = "sftp-middle-office-shared-network-test"
  app_name       = "test-sftp-server"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| s3_bucket_name | Name of the bucket. | `string` | `null` | yes |
| app_name | Name of the App. | `string` | `"sftp_test"` | no |


## Outputs

| Name | Description |
|------|-------------|
| bucket | The SFTP bucket. |
| bucket_id | Name of the S3 bucket. |
| bucket_arn | ARN of the S3 bucket. |
