
variable "access_key" {}
variable "secret_key" {}

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
  bucket = "vlad_terraform_getting_started_guide"
  acl    = "private"
}

resource "aws_instance" "example" {
  ami           = "ami-6d263d09" # Amazon Linux 2 LTS Candidate AMI 2017.12.0
#  ami           = "ami-403e2524" # Amazon Linux AMI 2017.09.1
  instance_type = "t2.micro"

  # Tells Terraform that this EC2 instance must be created only after the
  # S3 bucket has been created.
  depends_on = ["aws_s3_bucket.example"]
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}
