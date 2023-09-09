resource "aws_security_group" "vprofile-bean-elb-sg" {
    name = "vprofile-bean-elb-sg"
    description = "Security group for bean-elb"
    vpc_id = module.vpc.vpc_id
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
}

resource "aws_security_group" "vprofile-bastion-sg" {
    name = "vprofile-bastion-sg"
    description = "Security group for ec2 instance Bastion Host"
    vpc_id = module.vpc.vpc_id

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.MYIP]
    }
}


resource "aws_security_group" "vprofile-prod-sg" {
    name = "vprofile-prod-sg"
    description = "Security group for Beanstalk ec2 instances"
    vpc_id = module.vpc.vpc_id

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [aws_security_group.vprofile-bastion-sg.id]
    }
  
}


resource "aws_security_group" "vporfile-backend-sg" {
    name = "vporfile-backend-sg"
    description = "Security group for RDS, active MQ, Elastic Cache"
    vpc_id= module.vpc.vpc_id

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [aws_security_group.vprofile-prod-sg.id]
    }
}

resource "aws_security_group_rule" "sec_group_allow_itself" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_group_id = aws_security_group.vporfile-backend-sg.id
    source_security_group_id = aws_security_group.vporfile-backend-sg.id
}