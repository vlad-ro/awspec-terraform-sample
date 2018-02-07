
variable "access_key" {}
variable "secret_key" {}

variable "amis" {
  type = "map"
  default = {
    "amazon-linux" = "ami-403e2524"   # Amazon Linux AMI 2017.09.1
    "amazon-linux-2" = "ami-6d263d09" # Amazon Linux 2 LTS Candidate AMI 2017.12.0
  }
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "eu-west-2"
}

# New resource for the S3 bucket our application will use.
resource "aws_s3_bucket" "example" {
  # NOTE: S3 bucket names must be unique across _all_ AWS accounts, so
  # this name must be changed before applying this example to avoid naming
  # conflicts.
  bucket = "vlad-terraform-getting-started-guide"
  acl    = "private"
}

resource "aws_instance" "example" {
  ami           = "${var.amis["amazon-linux-2"]}" 
  instance_type = "t2.micro"

  # Tells Terraform that this EC2 instance must be created only after the
  # S3 bucket has been created.
  depends_on = ["aws_s3_bucket.example"]

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}
