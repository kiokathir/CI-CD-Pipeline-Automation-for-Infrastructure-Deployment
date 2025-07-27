provider "aws" {
    region = "ap-south-1"  
}

resource "aws_instance" "foo" {
  ami           = "ami-0d03cb826412c6b0f" # ap-south-1
  instance_type = "t2.micro"
  tags = {
      Name = "TF-Instance"
  }
}
