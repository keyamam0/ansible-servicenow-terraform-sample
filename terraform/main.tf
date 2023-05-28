#variable "backend_key" {
#  type    = string
#  default = "terraform.tfstate"
#}

# Backend Set
terraform {
  backend "s3" {
    #bucket = "keyamamo-demo"
    #key    = var.backend_key #tfstatファイルの名称
    #region = "ap-northeast-1"
  }
}

# AWS Provider Config

variable "key_name" {
  default = "my-keypair-tmp"
}

variable "TF_VAR_tag" {
  default = "sample_tag"
}

provider "aws" {
  region = "ap-northeast-1"
  # access_key = "xxxx"
  # secret_key = "xxxx"
}

# AWS Resource Create
resource "aws_instance" "tf-ec2-01" {
  ami = "ami-01b32aa8589df6208"
  instance_type = "t2.micro"
  key_name = var.key_name
  availability_zone = "ap-northeast-1a"
  #vpc_security_group_ids = ["<セキュリティグループID>"]
  tags = {
    Name = "HelloAnsible-01"
    myGroup = var.TF_VAR_tag
  }
}

resource "aws_instance" "tf-ec2-02" {
  ami = "ami-01b32aa8589df6208"
  instance_type = "t2.micro"
  key_name = var.key_name
  availability_zone = "ap-northeast-1a"
  #vpc_security_group_ids = ["<セキュリティグループID>"]
  tags = {
    Name = "HelloAnsible-02"
    myGroup = var.TF_VAR_tag
  }
}

# EBSボリュームの作成
resource "aws_ebs_volume" "tf-ebs-01" {
  availability_zone = "ap-northeast-1a"
  size              = 50
}

# EC2インスタンスへのEBSボリュームのアタッチ
resource "aws_volume_attachment" "example_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.tf-ebs-01.id
  instance_id = aws_instance.tf-ec2-01.id
}