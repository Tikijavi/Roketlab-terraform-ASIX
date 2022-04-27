# Crea una nova VPC
resource "aws_vpc" "my_vpc" {
  cidr_block    = "192.168.0.0/16"
  enable_dns_hostnames = true

  tags = {
        Name = "my_vpc"
  }
}

# Crea una subnet pública per Rocketchat
resource "aws_subnet" "public_subnet" {
  vpc_id        = aws_vpc.my_vpc.id
  cidr_block = "192.168.5.0/24"
  map_public_ip_on_launch = true

  tags = {
        Name = "public_subnet"
  }
}
