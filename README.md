This is an Example Application Build a Hello APP in Terraform using AWS

The component used to build the application 
ECS
VPC
Cloudwatch
KMS
ALB
S3
IAM


To run the application go the root directory and tun the initialize_server.sh script

In order to run the script you will need to have awscli, terraform (version 0.14 or higher) and access to a AWS ACCOUNT

You also need to create an backend s3 bucket to store the state file (i did not create this or a lock file due to time)
The script will firstly create a example hello app dockerfile 
It will then push you dockerfile to ECR-REPOSITORY which is created in the script

The ECR Repository need to be validate so this is done.

The next step is to build the infrastructure in AWS using ECS

The ECS is used alongside a Load Balancer for scaling purposes and uses cloudwatch for monitoring

The script will provide a option for you to confirm if you want to run the terraform infrastructure this is do a Terraform apply which will do a plan and if yes is selected it run the infrastructure
**Note this infrastructure has not been fully Tested so maybe a few bugs that need to be fixed.