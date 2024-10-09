module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.cidr

  azs = data.aws_availability_zones.azs.names
  #   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = var.public_cidr

  #   enable_nat_gateway = true
  #   enable_vpn_gateway = true

  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "jenkin-vpc"
  }

  public_subnet_tags = {
    Name : "jenkin-public-subnet"
  }
}


#  security group 

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-server-sg"
  description = "Security group for jenkin"
  vpc_id      = module.vpc.vpc_id

  #   ingress_cidr_blocks      = ["10.10.0.0/16"]
  #   ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name = "Jenkins-server-sg"
  }
}


# creating ec2

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "single-instance"
  ami                         = "ami-0866a3c8686eaeeba"
  instance_type               = var.ec2_instance
  key_name                    = var.key_name
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("userData.sh")
  availability_zone           = data.aws_availability_zones.azs.names[0]
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "jenkins-server"
  }
}
