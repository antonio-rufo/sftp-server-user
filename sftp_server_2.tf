###############################################################################
# SFTP Server 2
###############################################################################
module "sftp_server_module_2" {
  source                 = "./transfer_sftp_server_module/"
  name                   = "sftp_test.sftp_server_2"
  iam_role_name          = "sftp-logging-role-2"
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [module.security_group_ec2.security_group_id]
  log_group_name         = "sftp_server_log_group_2"

  tags = {
    Environment = var.environment
  }
}
