resource "aws_instance" "name" {
  key_name      = aws_key_pair.aws_key.key_name
  ami           = "ami-0c8e23f950c7725b9"
  instance_type = "t2.micro"
}

resource "null_resource" "n1" {
  
  connection {
    type        = "ssh"
    port        = 22
    user        = "ec2-user"
    host        = aws_instance.name.public_ip
    private_key = file(local_file.ssh_key.filename)
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.name.private_ip} > serverIP.log"
  }

  provisioner "file" {
    source      = "serverIP.log"
    destination = "/home/ec2-user/serverIP.log"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ec2-user/serverIP.log /opt/serverIP.log",
      "touch serge",
      "mkdir kwame"
    ]
  }


  depends_on = [aws_instance.name, local_file.ssh_key]
}
