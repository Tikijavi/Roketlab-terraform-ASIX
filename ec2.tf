# Instància EC2 amb la instal·lació del rocket chat
resource "aws_instance" "Rocket-Chat" {
  depends_on = [aws_internet_gateway.public_internet_gw]
  ami           = var.ami_ec2
  instance_type = var.instance_type_ec2
  key_name      = aws_key_pair.keypair.key_name
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.SG_public_subnet.id]
  tags = {
     Name = "Rocket Chat"
  }

   user_data = templatefile("rocket.sh", {
  })



 provisioner "local-exec" {
  command = "echo ${aws_instance.Rocket-Chat.public_ip} > publicIP.txt"
 }
}

#CloudWatch
resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.logs_path
  retention_in_days = var.log_group_retention_in_days
  kms_key_id        = var.log_group_kms_key_id
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = var.logs_path
  log_group_name = aws_cloudwatch_log_group.log_group.name
}
