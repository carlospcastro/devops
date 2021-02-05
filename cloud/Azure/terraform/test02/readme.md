## Azure Virtual Machine with Terraform

If you are ~40 years old, back to the old days how much time you were used to spend to install a brand new computer and have it ready to go? For sure it was days, weeks, sometimes I would say months, starting with the getting budget to buy a physical machine, until install the OS in it, what a long journey right?! So now, it takes minutes .. if you could tell this to your “young you” would you believe in you ( whaat 😳 ?!?!).

In this case with Azure and Terraform is possible to create a virtual machine in minutes, let’s check this out.

Pre requirements to get started with Terraform with Azure

- Azure account ready to go
- [Create your Azure free account today | Microsoft Azure](https://azure.microsoft.com/en-us/free/search/?&ef_id=Cj0KCQiAx9mABhD0ARIsAEfpavQZDm9_-PGlK3673LcaOe3Qkpn_nR9gRjPMpLhkoB7yxONAkHj40qYaAn04EALw_wcB:G:s&OCID=AID2100049_SEM_Cj0KCQiAx9mABhD0ARIsAEfpavQZDm9_-PGlK3673LcaOe3Qkpn_nR9gRjPMpLhkoB7yxONAkHj40qYaAn04EALw_wcB:G:s)
- Terraform CLI installed
- [https://learn.hashicorp.com/tutorials/terraform/install-cli](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Clone the repository

```bash
git clone https://github.com/carlospcastro/devops.git 
cd devops/cloud/Azure/terraform/test02/
```

## **Azure login**

```bash
# To login to Azure
az login 

# To find your subscription
az account list -o table

# To set properly your desired subscription
az account set --subscription <id>
```

## **Environment variable**

You can setup env variables via command line or pass the values through the terraform command line `terraform -var`

Fill out the env_vars.sh with your values and then run the command below

```bash
source env_vars.sh
```

## **Terraform**

```bash
# Run terraform
terraform init
terraform plan

# To apply the changes
terraform apply
```

## **Resources created**

![https://carlospcastro.com/wp-content/uploads/2021/02/Screenshot-2021-02-05-at-19.48.51-1024x454.png](https://carlospcastro.com/wp-content/uploads/2021/02/Screenshot-2021-02-05-at-19.48.51-1024x454.png)

## **Login to machine**

![https://carlospcastro.com/wp-content/uploads/2021/02/Screenshot-2021-02-05-at-20.18.32.png](https://carlospcastro.com/wp-content/uploads/2021/02/Screenshot-2021-02-05-at-20.18.32.png)

## **Clean up**

```bash
# Run terraform to destroy everything
terraform destroy
```