# Initialisation

This Terraform code creates AWS Transfer Family SFTP server.

# Pre-requisite

- A valid AWS profile ready to use via CLI
- Terraform version > 1.1.5 (version 1.3.7 suggested)

# Step-by-step guide

1. In `main.tf` you can put your generic services like VPC (I think you have this in a different place), security groups, s3 buckets.

2. Then when you want to create a SFTP server and its user/s, you can create a separate file for each SFTP server.

Like in this sample, we have 2 SFTP servers, with each SFTP server having its individual file (`sftp_server_1.tf` and `sftp_server_2.tf`).  
