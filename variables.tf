# variables.tf

#
# provider.tf
#
 
variable "aws_region" {
  description = "Region AWS"
  type        = string
  default     = "us-east-1"
}

#
# instances.tf
#

# claus

variable "key_pair" {
  description = "SSH Key pair used to connect"
  type        = string
  default     = "mykey"
}

# ec2

variable "ami_ec2" {
  description = "ec2 ami"
  type        = string
  default     = "ami-01b996646377b6619"
}

variable "instance_type_ec2" {
  description = "ec2 type"
  type        = string
  default     = "t2.micro"
}

#Cloudwatch
variable "logs_path" {
  description = "Path of the logs in CloudWatch"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags"
}

variable "log_group_retention_in_days" {
  description = "(Optional) Specifies the number of days you want to retain log events in the specified log group. Default to 30 days"
  type        = number
  default     = 30
}

variable "log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
  default     = ""
}
