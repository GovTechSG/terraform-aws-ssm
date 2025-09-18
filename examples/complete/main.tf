module "session_manager" {
  source = "../../"

  ssm_document_name           = "SSM-SessionManagerRunShell"
  kms_key_id                  = "<your-kms-key-id>"
  s3_bucket_name              = "<your-s3-bucket>"
  s3_key_prefix               = "logs/ssm"
  s3_encryption_enabled       = true
  cloudwatch_log_group_name   = "<your-log-group>"
  cloudwatch_encryption_enabled = true
  cloudwatch_streaming_enabled  = true
  idle_session_timeout        = 20
  max_session_duration        = 60
  run_as_enabled              = true
  run_as_default_user         = "ec2-user"
  linux_shell_profile         = "echo 'Welcome to SSM!'"
  windows_shell_profile       = "Write-Host 'Welcome to SSM!'"
}

# If you have an existing SSM document, import it before apply:
# terraform import aws_ssm_document.session_manager_prefs SSM-SessionManagerRunShell
