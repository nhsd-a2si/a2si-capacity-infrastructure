# Note - if you are using a different AWS CLI profile other than the default
# "default", you will need to override this variable in your `local.auto.tfvars`
# and name that same profile in the file `terraform.tf`.
variable "deployment_version" {
  description = "The version of the deployment so we can be sure that what has been deployed is the correct version"
  type = "string"
}

variable "aws_profile" {
  description = "AWS credentials and config profile to use for acting user"
  default = "default"
}

variable "aws_region" {
  description = "Region within which the resources will be deployed"
  default = "eu-west-2"
}


# Different availability zones are essentially different 'datacentres'
variable "aws_azs" {
  description = "Availability zones within which the resources will be deployed"
  type = "list"
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "vpc_cidr" {
  description = "IP range (CIDR) to use for the VPC"
  default = "10.0.0.0/16"
}

# Note that these are subnets of the vpc_cidr range
variable "public_subnet_cidrs" {
  description = "IP ranges (CIDR ranges) to use for the public subnets"
  type = "list"
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "capacity_public_subnet_rt" {
  description = "Capacity Route Table"
  type = "string"
  default = "Capacity Public Subnet RT"
}

variable "environment" {
  description = "Short name to differentiate this environment from others"
  default = "a2si-cd-dev"
}

variable "capacity_hosted_zone" {
  description = "The domain name for the existing Route53 Hosted Zone into which services and certificates will be placed (no trailing dot)"
  type = "string"
}

variable "capacity_service_fq_domain_name" {
  description = "Hostname to use for the capacity service - fully qualified. Must be 'within' the capacity_hosted_zone namespace"
  default = "capacity-service"
}

variable "metrics_service_fq_domain_name" {
  description = "Hostname to use for the metrics service - fully qualified. Must be 'within' the capacity_hosted_zone namespace"
  default = "metrics-service"
}

variable "reporting_service_fq_domain_name" {
  description = "Hostname to use for the reporting service - fully qualified. Must be 'within' the reporting_hosted_zone namespace"
  default = "reporting-service"
}

variable "dos_proxy_fq_domain_name" {
  description = "Hostname to use for the dos proxy service - fully qualified. Must be 'within' the capacity_hosted_zone namespace"
  default = "dos-proxy"
}

variable "s3_app_versions_bucket" {
  description = "Name of S3 bucket in which app versions will be stored"
  type = "string"
}

variable "s3_capacity_service_object" {
  description = "Object name of ZIP file containing Capacity Service version for deployment"
  type = "string"
}

variable "s3_metrics_service_object" {
  description = "Object name of ZIP file containing Metrics Service version for deployment"
  type = "string"
}

variable "s3_reporting_service_object" {
  description = "Object name of ZIP file containing Reporting Service version for deployment"
  type = "string"
}

variable "s3_dos_proxy_object" {
  description = "Object name of ZIP file containing DoS Proxy version for deployment"
  type = "string"
}

# Capacity Service
variable "capacity_service_spring_profiles_active" {
  default = "capacity-service-aws-redis"
}

variable "capacity_service_username" {
  description = "Basic auth username accepted by the capacity service"
  default = ""
}

variable "capacity_service_password" {
  description = "Basic auth password accepted by the capacity service"
  default = ""
}

variable "capacity_service_cache_ttl_seconds" {
  default = "604800"  # Time to live within Redis DB (1 week)
  type = "string"
}

variable "capacity_service_duration_wait_time_valid_seconds" {
  default = "1800"  # Time that a wait-time is valid for (30 mins)
  type = "string"
}

# DoS Proxy
variable "dos_service_domain" {
  description = "Endpoint Domain of the DoS"
  default = "uat.pathwaysdos.nhs.uk"
}

locals {
  dos_service_url = "https://${var.dos_service_domain}/app/api/webservices"
}

variable "dos_proxy_spring_profiles_active" {
  default = "doswrapper-aws-dos-soap-prod-cpsc-rest-aws"
}

#
# Variables for the capacity Service PostgreSQL DB
#

variable "postgres_db_instance" {
  default = "capacity-service-db"
}

variable "postgres_db_name" {
  default = "CapacityService"
}

variable "postgres_username" {
  default = "postmanpat"
}

variable "postgres_password" {
  type = "string"
}

# The following variables will be used to tag resources that are created by this Terraform configuration
variable "nhs_owner" {
  description = "Name of the person applying the changes"
  type = "string"
}

variable "nhs_owner_shortcode" {
    description = "Shortcode of the person applying the changes"
    type = "string"
}

variable "nhs_programme_name" {
  default = "a2si"
}

variable "nhs_project_name" {
  default = "capacity"
}

variable "healthcheck_url" {
  default = "healthcheck"
}

variable "amazon_aws_dynamo_table" {
  type = "string"
}

variable "amazon_aws_dynamo_endpoint" {
  default = "https://dynamodb.eu-west-2.amazonaws.com"
}

variable "amazon_aws_dynamo_region" {
  default = "eu-west-2"
}

variable "amazon_aws_dynamo_accesskey" {
  type = "string"
}

variable "amazon_aws_dynamo_secretkey" {
  type = "string"
}
