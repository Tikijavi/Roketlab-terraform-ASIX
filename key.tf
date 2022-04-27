# Claus de la instancia
resource "aws_key_pair" "keypair" {
    key_name    = var.key_pair
    #public_key  = "mykey.pub"
    public_key  = "${file("mykey.pub")}"
}
