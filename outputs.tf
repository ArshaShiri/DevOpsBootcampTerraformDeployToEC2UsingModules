# Output the public IP of created EC2
output "ec2_public_ip" {
    value = module.myapp-server.instance.public_ip
}