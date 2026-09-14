# terraform-project-ec2-dev-prod
Terraform AWS EC2 deployment using separate DEV and PROD variables with S3 remote state backend.


# Terraform Project 5 – AWS EC2 DEV/PROD

## Overview

This project demonstrates deploying AWS EC2 infrastructure using Terraform with separate DEV and PROD environment configurations.

The same EC2 configuration is used for both environments:

* AMI: `ami-08188a5a4dfdbd573`
* Instance type: `t3.micro`
* AWS Region: `ap-south-1`

The environment-specific EC2 name/tag is different:

* DEV → `Project5-DEV`
* PROD → `Project5-PROD`

Terraform remote state is stored in an existing AWS S3 bucket with separate state paths for DEV and PROD.

---

## Project Structure

```text
terraform-project5-ec2-dev-prod/
│
├── main.tf                  → Creates EC2 instance
├── variables.tf             → Defines input variables
├── outputs.tf               → Displays EC2 information
│
├── backend.tf               → Configures S3 as Terraform backend
├── backend-dev.tfvars        → DEV S3 state configuration
├── backend-prod.tfvars       → PROD S3 state configuration
│
├── variables-dev.tfvars      → DEV input values
└── variables-prod.tfvars     → PROD input values
```

---

## Terraform Configuration Flow

```text
variables.tf
     │
     ├── region
     ├── ami
     ├── instance_type
     └── instance_name
           │
           ├── variables-dev.tfvars
           │       └── Project5-DEV
           │
           └── variables-prod.tfvars
                   └── Project5-PROD

backend.tf
     │
     └── S3 backend
           │
           ├── backend-dev.tfvars
           │      └── project5/dev/terraform.tfstate
           │
           └── backend-prod.tfvars
                  └── project5/prod/terraform.tfstate
```

---

## DEV Execution

### 1. Format

```bash
terraform fmt
```

### 2. Initialize DEV S3 Backend

```bash
terraform init -reconfigure \
  -backend-config="backend-dev.tfvars"
```

### 3. Validate

```bash
terraform validate
```

### 4. Plan DEV

```bash
terraform plan \
  -var-file="variables-dev.tfvars"
```

Expected:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

### 5. Apply DEV

```bash
terraform apply \
  -var-file="variables-dev.tfvars"
```

Expected result:

```text
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

DEV EC2:

```text
Name: Project5-DEV
Instance type: t3.micro
Region: ap-south-1
```

---

## DEV Terraform State

Terraform state is stored remotely in S3:

```text
S3 Bucket:
terraform-tf-location

State:
project5/dev/terraform.tfstate
```

---

## PROD Execution

### 1. Initialize PROD S3 Backend

```bash
terraform init -reconfigure \
  -backend-config="backend-prod.tfvars"
```

### 2. Validate

```bash
terraform validate
```

### 3. Plan PROD

```bash
terraform plan \
  -var-file="variables-prod.tfvars"
```

### 4. Apply PROD

```bash
terraform apply \
  -var-file="variables-prod.tfvars"
```

PROD EC2:

```text
Name: Project5-PROD
Instance type: t3.micro
Region: ap-south-1
```

---

## PROD Terraform State

Terraform state is stored remotely in S3:

```text
S3 Bucket:
terraform-tf-location

State:
project5/prod/terraform.tfstate
```

---

## Key Concepts Demonstrated

* Terraform input variables
* `.tfvars` environment-specific values
* DEV and PROD configuration
* AWS provider
* AWS EC2 provisioning
* Terraform outputs
* S3 remote backend
* Separate DEV and PROD Terraform state
* `terraform init -reconfigure`
* `terraform validate`
* `terraform plan`
* `terraform apply`
* Infrastructure as Code (IaC)

## Environment Separation

```text
DEV
 │
 ├── variables-dev.tfvars
 └── project5/dev/terraform.tfstate


PROD
 │
 ├── variables-prod.tfvars
 └── project5/prod/terraform.tfstate
```

Both environments use the same Terraform code but different environment-specific values and separate remote state locations.
