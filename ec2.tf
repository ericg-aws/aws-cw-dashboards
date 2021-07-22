module "key_pair" {
  version     = ">= 1.0.0, < 2.0"
  source      = "terraform-aws-modules/key-pair/aws"

  key_name    = var.kpr_key_name
  public_key  = var.kpr_public_key
  tags        = local.common_tags
}

resource "aws_placement_group" "p_group" {
  name        = var.ec2_analytics_small_placement_group
  strategy    = "partition"
  tags        = local.common_tags
}

resource "aws_iam_instance_profile" "systems_manager" {
  name = "systems_manager"
  role = "AmazonSSMRoleForInstancesQuickSetup"
}

data "template_file" "ec2-prep" {
  template    = file("${path.module}/ec2-prep.sh")
}

module "ec2_instances" {
  source                  = "terraform-aws-modules/ec2-instance/aws"
  version                 = ">= 2.19.0, < 3.0"

  name                    = "${local.name_prefix}_jumphost"
  instance_count          = var.ec2_analytics_instance_count

  ami                     = var.ec2_analytics_small_ami_id
  instance_type           = var.ec2_analytics_small_instance_type
  iam_instance_profile    = "ec2_cloudwatch_ssm"
  vpc_security_group_ids  = [module.sgr_ssh.security_group_id]
  subnet_id               = module.vpc_01.public_subnets[0]
  key_name                = module.key_pair.key_pair_key_name
  monitoring              = true
  placement_group         = aws_placement_group.p_group.name

  tags                    = local.common_tags
}

resource "aws_volume_attachment" "ebs01_attach" {
  count = var.ec2_analytics_instance_count

  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.ebs01[count.index].id
  instance_id = module.ec2_instances.id[count.index]
}

resource "aws_ebs_volume" "ebs01" {
  count = var.ec2_analytics_instance_count

  availability_zone = module.ec2_instances.availability_zone[count.index]
  size              = 200
  type              = "gp3"
  tags              = local.common_tags
}

data "aws_ebs_volume" "ebs01" {
  most_recent = true

  filter {
    name   = "attachment.instance-id"
    values = ["${module.ec2_instances.id[0]}"]
  }
}