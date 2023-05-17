# Deploy to EC2 Using Modules Demo

## Modularize subnet
After moving related resources to subnet subfolder under their associated file, we have to make sure to call `terraform init`. We basically need to do so whenever modules change.

    terraform plan
    terraform apply --auto-approve