## Azure Kubernetes with Terraform

When we talk about kubernetes running natively in the cloud, usually we don't need to create virtual machines and install the kubernetes, we can if we want it, but there is a product called AKS ( Azure Kubernetes Service ) that we can use without take care of the admin nodes, only the worker nodes everything else is handled by Azure.

There are few ways to setup a new AKS cluster, either via Azure CLI or Azure Portal or Terraform. Today we gonna use Terraform to setup a completely fresh AKS cluster.

Pre requirements to get started with AKS using Terraform.

- Azure account ready to go

    [Create your Azure free account today | Microsoft Azure](https://azure.microsoft.com/en-us/free/search/?&ef_id=Cj0KCQiAx9mABhD0ARIsAEfpavQZDm9_-PGlK3673LcaOe3Qkpn_nR9gRjPMpLhkoB7yxONAkHj40qYaAn04EALw_wcB:G:s&OCID=AID2100049_SEM_Cj0KCQiAx9mABhD0ARIsAEfpavQZDm9_-PGlK3673LcaOe3Qkpn_nR9gRjPMpLhkoB7yxONAkHj40qYaAn04EALw_wcB:G:s)

- Azure CLI installed

    [Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

- Terraform CLI installed

    [https://learn.hashicorp.com/tutorials/terraform/install-cli](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Azure login

```bash
# To login to Azure
az login 

# To find your subscription
az account list -o table

# To set properly your desired subscription
az account set --subscription <id>
```

## Create Service Principal

Kubernetes needs a service principal to manage the AKS cluster and other Azure resources

```bash
# Create Service Principal
az ad sp create-for-rbac --skip-assignment --name sp-isis -o json

# Grant access to service principal perform changes in the subscription
az role assignment create --assignee <appId> \
--scope "/subscriptions/<subscription id>" \
--role Contributor
```

## Environment variable

You can setup env variables via command line or pass the values through the terraform command line `terraform -var`

Fill out the env_vars.sh with your values and then run the command below

```bash
source env_vars.sh
```

## Terraform

```bash
# Run terraform
terraform init
terraform plan

# To apply the changes
terraform apply
```
## Connect to Kubernetes
```bash
az aks get-credentials -n isis -g isis
```

## Clean up

```bash
# Run terraform to destroy everything
terraform destroy
```
