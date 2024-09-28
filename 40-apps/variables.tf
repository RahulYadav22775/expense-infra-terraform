variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {

    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
    }
}


variable "mysql_tags" {

    default = {
        Component = "mysql"
    }
}

variable "backend-tags" {

    default = {
        Component = "backend"
    }
}

variable "frontend-tags" {

    default = {
        Component = "frontend"
    }
}

variable "ansible-tags" {
    default = {
        Component = "ansible"
    }
}

variable "zone_name" {
    default = "gopi-81s.online"
}