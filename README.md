# dmk-aws-fargate

A hello world demo with AWS FARGATE using `terraform`

## Install

This demo requires you to install [`terraform`](https://www.terraform.io/)


# Setup

`terraform` scripts will require you to create an AWS account with the correct policies and roles applied.  Once you have created the account it will need to be set in `~/.aws/credentials`

Edit `src/terraform/int-ecs-vars.tf` and change `local.current_aws_account_arc` to the account you just created. This value will be used for the S3 bucket policy used during logging by the load balancer.

Edit `src/terraform/int-ecs-vars.tf` and change `local.lb_logs_bucket` to an S3 bucket to hold you load balancer logs.  This S3 bucket will be created by terraform.

Edit `src/terraform/init-ecs-setup.tf` and change `bucket` to a value to hold the remote terraform configuration. S3 buckets need to be unique.



## Initialize

`terraform` requires an initialization step to download the aws plugin dependencies

```
cd src/terraform
terraform init
```


## Run

```
cd src/terraform
terraform apply
# type yes to accept the plan
```

You should see a plan to create a bunch of resources, accept the plan by typing `yes`

The resources will be created. Visit the AWS console, get the name of the load balancer or container public IP. Visit that IP over http on port 80, and see the default nginx home page. This is a first step to deploying fault tolerant and scalable microservices!


## Cleanup

Remember to clean up the resources so you are not charged for them.

```
cd src/terraform
terraform destroy
# type yes to accept the plan
```

## Issues

The user account used by `terraform` may need certain AWS permissions set. I did not automate this step.

When destroying the resources, the s3 bucket will not be deleted if it is not empty. I just delete the bucket manually.

Cost tags are not applied everywhere they could.