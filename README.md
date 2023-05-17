# Deploy to EC2 Using Modules Demo
This is the modularized version of [DevOpsBootcampTerraformDeployToEC2](https://github.com/ArshaShiri/DevOpsBootcampTerraformDeployToEC2) repository.
## Modularize subnet
After moving related resources to subnet subfolder under their associated file, we have to make sure to call `terraform init`. We basically need to do so whenever modules change.

    terraform plan
    terraform apply --auto-approve

## Modularize webserver
The same steps as above are followed.

    terraform init
    terraform plan
    terraform apply --auto-approve