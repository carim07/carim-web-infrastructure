# Infrastructure for carim.ar

This repository holds all things required to launch carim.ar static website in AWS. The site is hosted in S3, served by CloudFront over HTTPS and Route53 handles DNS.

The goal is not just to create the Terraform files in a way that it just works, but to use this as an example of how to implement Terraform repository best practices, as described [here](https://www.hashicorp.com/resources/terraform-repository-best-practices)

I was inspired by [this](https://registry.terraform.io/modules/vexingcodes/s3-static-site/aws/latest) Terraform module from [Aaron Jones](https://registry.terraform.io/namespaces/vexingcodes). Kudos to him for his work. I reorganized and adapted the code to work with new Terraform version.

## Overview

* An s3 bucket `carim.ar` actually hosts the site.
* Another bucket `www.carim.ar` is configured to redirect to the main one.
* The two buckets are not publicly accessible.
* The site is delivered by CloudFront, where HTTP to HTTPS redirection is configured
* There is a single certificate issued by Amazon Certificate Manager for both `www.carim.ar` and `carim.ar`, and associated with both CloudFront distributions
* A secret is needed that is shared between the S3 bucket and Cloudfront to access the files.

## Requisites

* [Terraform](https://www.terraform.io/) [v0.15.0](https://releases.hashicorp.com/terraform/0.15.0/)

## Installation

In the `terraform/env/production` folder, you can modify the `config.tf` to adjust to your configuration, and create a `variables.tfvars` with the values of the only 2 variables that are required, such as

    site_domain=mydomain.com
    secret=mysecret

Once adjusted, run the following to prepare Terraform

    export AWS_PROFILE=*****
    terraform init
    terraform plan -var-file variables.tfvars -out terraform-plan.tfplan

Verify that the plan makes sense, and then run the following to apply

    terraform apply -var-file variables.tfvars terraform-plan.tfplan

Then you should be ready to deploy the site into the bucket `s3://site_domain`

