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
