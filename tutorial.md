# Infrastructure as code

**Time to complete**: About 30 minutes

Click the **Continue** button to move to the next step.

## Setup

**Tip**: Click the copy button on the side of the code box and paste the command in the Cloud Shell terminal to run it.

Check if terraform is installed
```bash
terraform -v
```

If not execute the terraform install script
```bash
./terraformInstall.sh
```
Click the **Continue** button to move to the next step.

## Create Compute Instance

```bash
export PROJECT_NAME=devops-live
```

```bash
export TF_VAR_project_name=devops-live
```

Create the `compute.tf` file:
```
variable "project_name" {}
resource "google_compute_instance" "terraform" {
 project = "${var.project_name}"
 zone = "us-central1-a"
 name = "tf-compute-${random_id.id.hex}"
 machine_type = "f1-micro"
 boot_disk {
   initialize_params {
     image = "ubuntu-1604-xenial-v20170328"
   }
 }
 network_interface {
   network = "default"
   access_config {
   }
 }
}

resource "random_id" "id" {
 byte_length = 6
}

output "instance_id" {
 value = "${google_compute_instance.terraform.self_link}"
}
```

Initialize Terraform
```bash
terraform init
```

Preview the changes
```bash
terraform plan
```

Apply the changes
```bash
terraform apply
```

Enter 'yes' to accept the changes:
```bash
yes
```

Confirm the instance is up and running:
```bash
gcloud compute instances list
```

Clean up
```bash
terraform destroy
```

Enter 'yes' to accept the destroy:
```bash
yes
```

Click the **Continue** button to move to the next step.

## Congrats!

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>
