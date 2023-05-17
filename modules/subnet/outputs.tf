# We are outputting our subnet module which then can be used by other modules.
output "subnet" {
    value = aws_subnet.myapp-subnet-1
}