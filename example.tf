variable "profile" {}

variable "amis" {
  type = "map"

  default = {
    "amazon-linux"   = "ami-403e2524" # Amazon Linux AMI 2017.09.1
    "amazon-linux-2" = "ami-6d263d09" # Amazon Linux 2 LTS Candidate AMI 2017.12.0
  }
}

provider "aws" {
  region  = "eu-west-2"
  profile = "${var.profile}"
}

terraform {
  backend "s3" {
    bucket = "vlad-terraform-state"
    key    = "getting-started-guide.tfstate"
    region = "eu-west-2"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs = ["eu-west-2a"]

  public_subnets = ["10.0.101.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "example" {
  ami           = "${var.amis["amazon-linux-2"]}"
  instance_type = "t2.micro"
  subnet_id     = "${module.vpc.public_subnets[0]}"

  tags {
    Name = "example"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

output "ip" {
  value = "${aws_eip.ip.public_ip}"
}
