
resource "aws_instance" "public_instance" {
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = file("scripts/userdata.sh")




  // Crear la instancia de manera local
  provisioner "local-exec" {
    command = "echo instancia creada con IP ${aws_instance.public_instance.public_ip} >> datos_instancia.txt"

  }
  //Destruir la instancia de manera local
  provisioner "local-exec" {
    when    = destroy
    command = "echo instancia  ${self.public_ip} >> Destruida datos_instancia.txt"

  }

}

/*
  provisioner "remote-exec" {
    inline = [
      "echo 'Hola Mundo' >~/saludo.txt"
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("myKey.pem")

    }

  }
*/
/*lifecycle { ******************Permite hacer cambios en los recuros
    replace_triggered_by = [ 
      aws_subnet.private_subnnet
    
     ]

 /* tags = {
    Name = "My_instance"
    
  }/*
  }*/
