# We can output the result of the aws_ami query here for checking.
# We can use terraform plan to check the output
output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
}

# Output the public IP of created EC2
output "ec2_public_ip" {
    value = aws_instance.myapp-server.public_ip
}