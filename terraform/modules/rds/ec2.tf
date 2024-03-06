resource "aws_key_pair" "kp" {
    key_name = "kp"
    public_key = file("../modules/rds/kp.pub") 
}

resource "aws_instance" "bastion_host" {
    ami = "ami-0f5daaa3a7fb3378b"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id
    key_name = aws_key_pair.kp.key_name
    vpc_security_group_ids = [aws_security_group.web_sg.id]
}

resource "aws_eip" "web_eip" {
    instance = aws_instance.bastion_host.id
}

