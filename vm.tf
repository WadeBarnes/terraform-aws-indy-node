# ====================================================================================================
# Notes:
# ----------------------------------------------------------------------------------------------------
# The module supports creating node instances with or without elastic IPs,
# by setting the 'use_elastic_ips' variable to 'true' or 'false'.
# This supports the scenario where you want to create a network of nodes in the same region.
# AWS only supports 5 elastic IPs per region, which is not enough to support
# the minimum of four nodes for the network.

# You can request more elastic IP by contacting AWS support though.  
# The same applies for VPC and internet gateways, which have a "soft" limit of 5, but can be extended 
# by contacting support or using the AWS ServieQuotas console

# When 'use_elastic_ips' is set to false a public IP address is assigned to the instance by default
# and only a single interface and subnet are created.  Meaning the node will need to share the one
# interface for both node and client communications.  Otherwise, separate interfaces and subnets
# are created for node and client communication and each interface is assigned an elastic IP.
# ====================================================================================================

resource "aws_instance" "indy_node" {
  ami           = var.ami_id
  instance_type = var.ec2_instance_type

  iam_instance_profile = var.iam_profile

  # Set the hostname
  # This will be used by the Ansible scripts as the alias for the node.
  user_data = "#!/usr/bin/env bash\nsudo hostnamectl set-hostname --static ${var.instance_name}"
  key_name  = var.ssh_key_name

  # ===============================================================
  # Provinces Hosting in AWS will want to ensure their
  # nodes are in different availability zones
  # ---------------------------------------------------------------
  availability_zone = var.zone
  # ===============================================================

  #this lifecycle is to prevent a rebuilt of the VM when the original AMI used changes, which happens often and quickly. 
  lifecycle {
    ignore_changes = [
      ami,
    ]
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.ebs_volume_type
    encrypted   = var.ebs_encrypted
    # ===============================================================
    # This ID is specific to a specific account:
    #   - Encrypted volume required?
    #     - For this the AMI being used; yes.
    #     - Seems to be specific to the Protected B environment.
    #   - Make dynamic if using an encrypted volume
    #   - Keys will need to be protected from accedental distruction
    # ---------------------------------------------------------------
    # kms_key_id            = var.ebs_kms_key_id
    # ===============================================================
    delete_on_termination = var.ebs_delete_on_termination

    tags = {
      # Default tags don't reach this level.
      Name        = "${var.instance_name} - Root Volume"
      Application = var.application_name
      Environment = var.environment
      Instance    = var.instance_name
      Zone        = var.zone
    }

  }

  # Default (primary) network interfaces can only be attached here.
  network_interface {
    network_interface_id = aws_network_interface.node_nic.id
    device_index         = 0
  }

  depends_on = [
    aws_internet_gateway.node_gateway
  ]

  tags = {
    Name     = var.instance_name
    Instance = var.instance_name
  }
}
