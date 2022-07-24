variable "instance_name" {
  description = "The value to use for the Name tag of the EC2 instance"
}

variable "application_name" {
  description = "The name of the application."
}

variable "environment" {
  description = "The name of the environment."
}

variable "ami_id" {
  description = "AMI to use for the instance."
}

variable "default_vpc_id" {
  description = "The ID of the default VPC."
}

variable "ec2_instance_type" {
  description = "Type of instance ec2"
}

# ToDo:
#   - Has Not Been Setup in Test yet
#   - Uncomment as son as possible
# variable "iam_profile" {
#   description = "The IAM profile to attach to the ec2 instance."
# }

variable "ebs_volume_size" {
  description = "EBS volume size"
}

variable "ebs_volume_type" {
  description = "EBS volume type"
}

variable "ebs_encrypted" {
  description = "EBS is encrypted"
}

variable "ebs_kms_key_id" {
  description = "KMS key used to encrypt/decrypt EBS"
}

variable "ebs_delete_on_termination" {
  description = "EBS delete on termination"
}

variable "subnet_node_cidr_block" {
  description = "The cidr block to use for the node subnet."
}

variable "subnet_client_cidr_block" {
  description = "The cidr block to use for the client subnet."
}

variable "use_elastic_ips" {
  description = "The cidr block to use for the client subnet."
  type = bool
}

variable "ssh_source_address" {
  description = "The source IP address for SSH connections, in CIDR notation."
}
variable "public_ssh_key" {
  description = "The public SSH key to associate with the instance."
}

variable "client_port" {
  description = "The port, within the indy range of 9700 to 9799, on which the client interface will listen."
  default     = "9702"
}

variable "node_port" {
  description = "The port, within the indy range of 9700 to 9799, on which the node interface will listen."
  default     = "9701"
}