# Terraform multi-cloud automation project
In this project we use Terraform to automate AWS and Azure cloud resources parallely using Terraform configuration.
 
 
## Build multi-cloud networking resources in Azure and AWS using Terraform
```bash
# Switch to Terraform project directory.
$ cd <PROJECT_ROOT_DIR>
 
# Initialize Terraform configuration.
$ terraform init
 
# Generate plan from Terraform configuration.
$ terraform plan -var-file var/PRD.tfvars -out plan/PRD.tfplan
 
# Apply Terraform plan.
$ terraform apply plan/PRD.tfplan
```