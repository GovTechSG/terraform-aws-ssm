# terraform-aws-ssm

## Purpose

This module manages AWS SSM Session Manager default preferences, allowing you to centrally configure session logging, encryption, and shell profiles. It is designed to:

- Set organization-wide defaults for Session Manager sessions (logging, encryption, shell profiles)
- Enable the use of the `runAs` feature, so sessions can start as a specific user (e.g., `ec2-user`) instead of the default `ssm-user`
- Help avoid the security risk of `ssm-user` always having sudo privileges
- Support secure, non-root/non-sudo access for SSM sessions

## Avoiding Root/Sudo Access with SSM Session Manager

To prevent all SSM sessions from using root/sudo by default:

1. **Create a non-root user** (e.g., `ssm-basic`) and an admin user (e.g., `ssm-admin`) on your EC2 instances.
2. **Tag IAM roles/users** needing admin/root access with `SSMSessionRunAs = ssm-admin`.
3. **Enable SSM RunAs** and set the default session user to your non-root user in Session Manager preferences.

This ensures most users get non-root access, while only tagged admins can use sudo/root.

## Importing an Existing SSM Document

If you have already created the SSM document in the AWS Console or elsewhere, you can import it into Terraform state before running `terraform apply`:

```bash
terraform import aws_ssm_document.session_manager_prefs SSM-SessionManagerRunShell
```

This will allow Terraform to manage the existing document without recreating it.

## Example Usage

See [`examples/complete/main.tf`](examples/complete/main.tf) for a full example of how to use this module.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_document.session_manager_prefs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_encryption_enabled"></a> [cloudwatch\_encryption\_enabled](#input\_cloudwatch\_encryption\_enabled) | Encrypt log data. | `bool` | `true` | no |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | The name of the log group to upload session logs to. Specifying this enables sending session output to CloudWatch Logs. | `string` | `""` | no |
| <a name="input_cloudwatch_streaming_enabled"></a> [cloudwatch\_streaming\_enabled](#input\_cloudwatch\_streaming\_enabled) | Stream session log data to CloudWatch. Defaults to true. If false logs will be uploaded at the end of the session. | `bool` | `true` | no |
| <a name="input_idle_session_timeout"></a> [idle\_session\_timeout](#input\_idle\_session\_timeout) | Time until a session is closed when left idle. | `number` | `20` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The KMS key used to to encrypt SSM sessions. | `string` | `null` | no |
| <a name="input_linux_shell_profile"></a> [linux\_shell\_profile](#input\_linux\_shell\_profile) | A set of Linux commands to run when a Linux session is started. | `string` | `""` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | The longest a session can stay open before it will be closed. | `number` | `null` | no |
| <a name="input_run_as_default_user"></a> [run\_as\_default\_user](#input\_run\_as\_default\_user) | The name of the user account to start sessions with on Linux managed nodes when the runAsEnabled input is set to true. The user account you specify for this input must exist on the managed nodes you will be connecting to; otherwise, sessions will fail to start. | `string` | `""` | no |
| <a name="input_run_as_enabled"></a> [run\_as\_enabled](#input\_run\_as\_enabled) | Enables the option to start sessions using the credentials of a specified operating system user. | `bool` | `false` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of bucket to store session logs. Specifying this enables writing session output to an Amazon S3 bucket. | `string` | `""` | no |
| <a name="input_s3_encryption_enabled"></a> [s3\_encryption\_enabled](#input\_s3\_encryption\_enabled) | Encrypt log data. | `bool` | `true` | no |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | To write output to a sub-folder, enter a sub-folder name. | `string` | `""` | no |
| <a name="input_ssm_document_name"></a> [ssm\_document\_name](#input\_ssm\_document\_name) | The name for SSM Document | `string` | `"SSM-SessionManagerRunShell"` | no |
| <a name="input_windows_shell_profile"></a> [windows\_shell\_profile](#input\_windows\_shell\_profile) | A set of Windows commands to run when a Windows session is started. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_document_arn"></a> [document\_arn](#output\_document\_arn) | ARN of the created document. You can use this to create IAM policies that prevent changes to Session Manager preferences. |
| <a name="output_document_type"></a> [document\_type](#output\_document\_type) | The type of the document |
| <a name="output_name"></a> [name](#output\_name) | Name of the created document. |
