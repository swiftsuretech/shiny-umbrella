# shiny-umbrella

Spins up an environment in AWS to represent and air-gapped cluster for ver 2.X. You will need to generate and provide a private key to use for the instances and drop that into the keys directory. Don't forget to update variables.tf in the terraform dir to point to it. 

Default deployment is minimum spec with a bastion node, 3 control planes and 4 worker nodes. Configurability is minimal to allow for simplicity, however, some arguments may be set in variables.tf in the infrastructure directory.

Ensure that you have AWS CLI installed on your deploying machine and that you update AWS profile name there also (probably to default).

The endstate is 8 x instances which meet the minimum spec for a bastion node, 3 x control planes and 4 worker nodes. The airgapped bundle is downloaded to /home/centos and unzipped ready to run the ./setup script as per the instructions.

Instructions:

* Ensure that terraform and AWS CLI are installed on your local machine.

* Clone this repo.

* Generate a keypair in the AWS console. This results in a download of the private key.

* Copy the private key from downloads to keys/{your-key}.pem. 

* Update infrastructure/variables.tf to point to your key.

* Ensure your AWS credentials are stored at the default ~/.aws/credentials.

* Make the setup file in the root dir executable and run it.
