# shiny-umbrella

Some Terraform to spin up an environment in AWS to represent and air-gapped cluster for ver 2.X. You will need to generate and provide a private key to use for the instances and drop that into the keys directory. Default deployment is minimum spec with a bastion node, 3 control planes and 4 worker nodes. Configurability is minimal to allow for simplicity, however, some variables may be set in variables.tf in the terraform directory.

Ensure that you have AWS CLI installed on your deploying machine and that you update AWS profile name there also (probably to default)
