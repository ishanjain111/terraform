resource "aws_instance" "nginx-instance" {
  ami                         = ""
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids = [ aws_security_group.nginx-sg.id ]
  root_block_device {
    delete_on_termination = true
    volume_size = 10
    volume_type = "gp3"
  }
}

resource "aws_security_group" "nginx-sg" {
    description = "Security group allowing traffic on port 443 and 80"
    name = "Public-http-traffic"
    vpc_id = aws_vpc.nginx-project.id
}

resource "aws_vpc_security_group_ingress_rule" "http" {
    security_group_id = aws_security_group.nginx-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "https" {
    security_group_id = aws_security_group.nginx-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}