# Backend Set
terraform {
  backend "s3" {
  }
}

# Variables
variable "keypair_name"{
}
variable "TF_VAR_tag"{
}
variable "TF_VAR_expire"{
}
variable "subnet_id"{
}
variable "a_zone"{
}

# AWS Provider Config
provider "aws" {
  region = "ap-northeast-1"
}

# EC2 Create
resource "aws_instance" "tf-ec2-A" {
  ami = "ami-01b32aa8589df6208"
  instance_type = "t2.micro"
  key_name = var.keypair_name
  availability_zone = var.a_zone
  subnet_id = var.subnet_id

  tags = {
    Name = "Type-A"
    myGroup = var.TF_VAR_tag
    expire = var.TF_VAR_expire
  }
}

resource "aws_instance" "tf-ec2-B" {
  ami = "ami-01b32aa8589df6208"
  instance_type = "t2.micro"
  key_name = var.keypair_name
  availability_zone = var.a_zone
  subnet_id = var.subnet_id

  tags = {
    Name = "Type-B"
    myGroup = var.TF_VAR_tag
    expire = var.TF_VAR_expire
  }
}

# EBS Create
resource "aws_ebs_volume" "tf-ebs-01" {
  availability_zone = var.a_zone
  size              = 50
}

# EC2インスタンスへのEBSボリュームのアタッチ
resource "aws_volume_attachment" "example_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.tf-ebs-01.id
  instance_id = aws_instance.tf-ec2-A.id
}