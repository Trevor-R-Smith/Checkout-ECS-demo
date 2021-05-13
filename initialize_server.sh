#!/bin/bash

# need to ensure you have docker, aws cli and terraform installed to run the bash script

# This script get runs an example Hello world application using AWS ECS ECR VPC

REGION=${aws configure list | grep region | awk '{print $2}'}
REPOSITORY-NAME="checkout-repository"

echo "Update you package"
sudo yum update -y

function install_aws_docker_components() {
 echo "Install the most recent Docker Community Edition package"
  sudo amazon-linux-extras install docker
  echo "Start the Docker service."
  sudo service docker start
  echo "Add the ec2-user to the docker group so you can execute Docker commands without using sudo"
  sudo usermod -a -G docker ec2-user
  DOCKER=docker info
  echo "You docker user name is $DOCKER"
}

function create_docker_file() {
  echo "hello" > hello
  echo -e "FROM busybox\nCOPY /hello /\nRUN cat /hello" > Dockerfile
  docker build -t helloapp:v1
}

function authenticate_registry() {
    echo "aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com"
    echo "Get-ECRLoginCommand).Password | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com"
}


function create_and_push_to_aws_repository() {
  echo "create ECR Repository"
  aws ecr create-repository \
  --repository-name REPOSITORY-NAME \
  --image-scanning-configuration scanOnPush=true \
  --region $REGION

  docker tag hello-world:latest aws_account_id.dkr.ecr.us-east-1.amazonaws.com/helloapp:latest

  docker push aws_account_id.dkr.ecr.us-east-1.amazonaws.com/helloapp:latest
}

function create_backend_tf_file() {
  cd Infrastructure

  read -p "Enter the terraform s3 bucket used for backend" TERRAFORM_BUCKET
  read -p "Please enter the name of your state file" TERRAFORM_STATE_KEY

  cp backend_tpl backend.tf
  perl -p -i -e "s/bucket_placeholder/${TERRAFORM_BUCKET}/" backend.tf
  perl -p -i -e "s/key_placeholder/${TERRAFORM_STATE_KEY}/" backend.tf
  perl -p -i -e "s/region_placeholder/${AWS_CURRENT_REGION}/" backend.tf


}

function create_terraform_vars_file() {
  cd Infrastructure

  read -p "Please enter a name for your application" APPLICATION_NAME
  read -p "Please entar a environment to deploy e.g Dev, Test Prod" ENVIRONMENT

  cp tf-variables.tpl terraform.tfvars
  perl -p -i -e "s/region_placeholdr/${AWS_CURRENT_REGION}/" terraform.tfvars
  perl -p -i -e "s/application_name_placeholder/${APPLICATION_NAME}/" terraform.tfvars
  perl -p -i -e "s/environment_placeholder/${ENVIRONMENT}/" terraform.tfvars
  perl -p -i -e "s/ecr_repository_name_placeholder/${REPOSITORY-NAME}/" terraform.tfvars

}

function initiate_terraform() {
  cd Infrastructure

  terraform init
  terraform validate

}

function terraform_plan() {
  cd Infrastructure

  terraform fmt --recursive

  read -p "Do you wish to apply the Terraform Infrastructure" run_terraform

  if [$run_terraform == "yes"]; then
    terraform apply bootstrap_tfplan -auto-approve
  else
    echo "You did not enter yes, the terraform plan has not been applied"
  fi

}

# install docker components
install_aws_docker_components
sleep 1s
create_docker_file
sleep 1s
authenticate_registry
create_and_push_to_aws_repository

#terraform application
initiate_terraform
sleep 2s
create_backend_tf_file
sleep 1s
create_terraform_vars_file
sleep 1s
terraform_plan