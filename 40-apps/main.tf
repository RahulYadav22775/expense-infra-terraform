module "mysql_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.resource_name}-mysql"
  ami = data.aws_ami.joindevops.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    var.mysql_tags,
    {
    Name = "${local.resource_name}-mysql"
  }
  )
}


module "backend_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.resource_name}-backend"
  ami = data.aws_ami.joindevops.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.backend-tags,
    {
    Name = "${local.resource_name}-backend"
  }
  )
}

module "frontend_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.resource_name}-frontend"
  ami = data.aws_ami.joindevops.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    var.frontend-tags,
    {
    Name = "${local.resource_name}-frontend"
  }
  )
}


module "ansible_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.resource_name}-ansible"
  ami = data.aws_ami.joindevops.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.ansible_sg_id]
  subnet_id              = local.public_subnet_id

  user_data = file("expense.sh")
  tags = merge(
    var.common_tags,
    var.ansible-tags,
    {
    Name = "${local.resource_name}-ansible"
  }
  )
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  
  zone_name = var.zone_name

  records = [
    {
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [
        module.mysql_instance.private_ip,
      ]
    },
   
    {
      name    = "backend"
      type    = "A"
      ttl     = 1
      records = [
        module.backend_instance.private_ip,
      ]
    },

    {
      name    = "frontend"
      type    = "A"
      ttl     = 1
      records = [
        module.frontend_instance.private_ip,
      ]
    },
    
    {
      name    = ""
      type    = "A"
      ttl     = 1
      records = [
        module.frontend_instance.public_ip,
      ]
    },

  ]
  
}