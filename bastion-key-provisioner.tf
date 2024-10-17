
# resource "null_resource" "copy_ec2_keys" {

#   depends_on = [module.ec2_bastion, aws_key_pair.TF_key, local_file.TF_key]

#   connection {
#     type     = "ssh"
#     host     = aws_eip.bastion_eip.public_ip
#     user     = "ec2-user"
#     password = ""
#     # private_key = file("private-key/eks-terraform-key.pem")
#     private_key = file(local_file.TF_key.filename)
#   }


#   provisioner "file" {
#     source      = " "
#     destination = "/tmp/eks-terraform-key.pem"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo chmod 400 /tmp/eks-terraform-key.pem"
#     ]
#   }
# }

