
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.2.0/24" #/24 --> 10.255.255.0 to   10.255.255.255   The 1st 24 bits are taken  8 bits = 256         posssibilities --> Subnet
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public sbnet-10.0.2.0 - us-east-1a"
  }
}

resource "aws_subnet" "public_subnet_e" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.3.0/24" #/24 --> 10.255.255.0 to   10.255.255.255   The 1st 24 bits are taken  8 bits = 256         posssibilities --> Subnet
  availability_zone       = "us-east-1e"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public sbnet-10.0.3.0 - us-east-1e"
  }
}



resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.4.0/24" #/24 --> 10.255.255.0 to   10.255.255.255   The 1st 24 bits are taken  8 bits = 256         posssibilities --> Subnet
  availability_zone       = "us-east-1d"
  map_public_ip_on_launch = false
  tags = {
    "Name" = "private sbnet-10.0.4.0 - us-east-1d"
  }
}
