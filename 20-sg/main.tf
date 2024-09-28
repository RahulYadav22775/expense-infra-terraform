module "mysql_sg" {
 source = "../../terraform-security-group"
 project_name = var.project_name
 environment = var.environment
 common_tags = var.common_tags
 vpc_id = local.vpc_id
 sg_tags = var.mysql_sg_tags
 sg_name = "mysql"

}

module "backend_sg" {

 source = "../../terraform-security-group"
 project_name = var.project_name
 environment = var.environment
 common_tags = var.common_tags
 vpc_id = local.vpc_id
 sg_tags = var.backend_sg_tags
 sg_name = "backend"

}

module "frontend_sg" {
 
 source = "../../terraform-security-group"
 project_name = var.project_name
 environment = var.environment
 common_tags = var.common_tags
 vpc_id = local.vpc_id
 sg_tags = var.frontend_sg_tags
 sg_name = "frontend"

}


module "bastion_sg" {
 
 source = "../../terraform-security-group"
 project_name = var.project_name
 environment = var.environment
 common_tags = var.common_tags
 vpc_id = local.vpc_id
 sg_tags = var.bastion_sg_tags
 sg_name = "bastion"

}


module "ansible_sg" {
 
 source = "../../terraform-security-group"
 project_name = var.project_name
 environment = var.environment
 common_tags = var.common_tags
 vpc_id = local.vpc_id
 sg_tags = var.ansible_sg_tags
 sg_name = "ansible"

}

# mysql accepts conection from backend
resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

# backend accepts conection from frontned
resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}

# frontned accepts conection from public
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_sg.sg_id
}


resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.frontend_sg.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}


resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id
}

resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ansible_sg.sg_id
}


resource "aws_security_group_rule" "mysql_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.sg_id
  security_group_id = module.frontend_sg.sg_id
}