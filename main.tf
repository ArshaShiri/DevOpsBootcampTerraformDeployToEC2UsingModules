# This would be the root module. The children modules are in the modules folder.

provider "aws" {
  region = "eu-west-3"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
      # dev-vpc, staging-vpc...
      Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
    source = "./modules/subnet"

    # We have to set the variables that are used in the subnet module.
    # We set them by referencing the variables defined in terraform.tfvars file.
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp-vpc.id
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

resource "aws_default_security_group" "default-sg" {
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name = "${var.env_prefix}-default-sg"
    }
}

# Querying the latest image id for AMI.
# You can check the information of AMI under EC2 AMI.
# The owner and other info are accessible there.
data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

# resource "aws_key_pair" "ssh-key" {
#     key_name = "server-key"
#     public_key = file(var.public_key_location)
# }

resource "aws_instance" "myapp-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    
    # We are using the output of the subnet module here.
    subnet_id = module.myapp-subnet.subnet.id

    # We can have a list of security groups here.
    vpc_security_group_ids = [aws_default_security_group.default-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true

    # Better not to hardcode this
    key_name = "server-key-pair"

    # Use instead:
    # key_name = aws_key_pair.ssh-key.key_name

    # This script runs only in the start of EC2 creation and in the subsequent runs it is not executed (Unless the resource is destroyed and created again of course)
    user_data = file("entry-script.sh")

    tags = {
        Name = "${var.env_prefix}-server"
    }
}
