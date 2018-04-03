# Infrastructure as code

**Time to complete**: About 45 minutes

Click the **Continue** button to move to the next step.

## Setup

**Tip**: Click the copy button on the side of the code box and paste the command in the Cloud Shell terminal to run it.

Set Google Cloud Project:
```bash
gcloud config set project devops-live
```

Check if terraform is installed:
```bash
terraform -v
```

If not execute the terraform install script:
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

Create the `compute.tf` file in the root of the project:
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

Initialize Terraform:
```bash
terraform init
```

Preview the changes:
```bash
terraform plan
```
Take note of the changes that Terraform is expecting to apply.

Apply the changes:
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

Open a different tab and navigate to the [Google Cloud Console](https://console.cloud.google.com/) and view the newly created Compute Instance.

Clean up:
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

Let's do something a bit more interesting...

Click the **Continue** button to move to the next step.

## Jenkins via Helm
In this section of the walkthrough we will setup a Kubernetes cluster using Terraform and install a Jenkins master worker setup using Helm.

Click the **Continue** button to move to the next step.

## Setup
Access the k8s (Kubernetes) directory:
```bash
cd k8s
```

Check if helm is installed:
```bash
helm -h
```

If not execute the helm install script:
```bash
./helmInstall.sh
```

Click the **Continue** button to move to the next step.

## Create Cluster

```bash
export PROJECT_NAME=devops-live
```

```bash
export TF_VAR_project_name=devops-live
```

Create the `cluster.tf` file:

```
variable "project_name" {}

provider "google" {
  region = "us-west1"
}

data "google_compute_zones" "available" {
  project = "${var.project_name}"
}

resource "google_container_cluster" "primary" {
  project 	     = "${var.project_name}"
  name               = "cicd-${random_id.id.hex}"
  zone               = "${data.google_compute_zones.available.names[random_integer.instance.result]}"
  initial_node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",]

    labels {
      env = "dev"
    }

    tags = ["env", "dev"]
  }
}

resource "random_id" "id" {
 byte_length = 4
}

resource "random_integer" "instance" {
  min     = 0
  max     = 2
}
```
Initialize Terraform:
```bash
terraform init
```

Preview the changes:
```bash
terraform plan
```

Apply the changes:
```bash
terraform apply
```

**Note** it may take a few minutes for the cluster to be available.

Enter 'yes' to accept the changes:
```bash
yes
```

Confirm the cluster is up and running:
```bash
gcloud container clusters list
```

Take note of the `NAME` and the `LOCATION` outputs, these will be used in the next step as the cluster_name and the zone, respectively.

Set the kubectl context to the cluster, this tells Kubernetes what cluster that you are interacting with:
```bash
gcloud container clusters get-credentials <cluster_name> --zone=<cluster_zone>
```
Example:
```bash
gcloud container clusters get-credentials cicd-d44bfe8b --zone=us-west1-a
```

Open a different tab and navigate to the [Google Cloud Console](https://console.cloud.google.com/) and view the newly created infrastructure.

Click the **Continue** button to move to the next step.

## Jenkins via helm
This Jenkins install is based on this [Google Cloud Tutorial](https://cloud.google.com/solutions/jenkins-on-kubernetes-engine). This is designed to run on Google's managed Kubernetes environment, GKE / k8s and relies on [helm](https://github.com/kubernetes/helm) for the install. Helm is a tool that streamlines installing and managing Kubernetes applications. Think of it like apt/yum/homebrew for Kubernetes.

Initialize helm
```bash
helm init
```
Note that the helm tiller may take up to 1 minute to initialize. If you receive the error below, please wait a minute and execute the attempted helm command again.

`Error: could not find a ready tiller pod`

Execute the helm Jenkins install:
```bash
helm install --set "Master.AdminPassword=techagile" stable/jenkins
```

Confirm the deployment installed:
```bash
kubectl get deployments
```

The deployment should be up starting up the Jenkins container and may not be available immediately.

Navigate the Google Cloud Console to the Kubernetes Engine panel, under Workloads you should see your Jenkins Deployment running.

Now move to the Discovery & load balancing section, here you will see services creating during the helm install.  Under the endpoint column for the Jenkins master, you will notice an IP has been created with port 8080 exposed.  Navigate to the IP in the browser.

You should now be at the Jenkins login page and can can access by using the user `admin` and the `Master.AdminPassword` you provided during setup.

This was a basic / default install of Jenkins, more customization can be applied during the `helm` install.

Clean up:
```bash
terraform destroy
```

Enter 'yes' to accept the destroy:
```bash
yes
```

Navigate the Google Cloud Console again and notice that all of the infrastructure and software has been destroyed.

Click the **Continue** button to move to the next step.

## Congrats!

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You have completed the walkthrough!
