# Note - if you are using a different AWS CLI profile other than the default
# "default", you will need to override this variable in your `local.auto.tfvars`
# and name that same profile in the file `terraform.tf`.
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


variable "environment" {
  description = "Short name to differentiate this environment from others"
  default = "dev"
}

variable "capacity_hosted_zone" {
  description = "The domain name for the existing Route53 Hosted Zone into which services and certificates will be placed (no trailing dot)"
  type = "string"
}

variable "sftp_fq_domain_name" {
  description = "Hostname to use for the sftp server - fully qualified. Must be 'within' the capacity_hosted_zone namespace"
  default = "sftp"
}

variable "capacity_service_fq_domain_name" {
  description = "Hostname to use for the capacity service - fully qualified. Must be 'within' the capacity_hosted_zone namespace"
  default = "capacity-service"
}

variable "info_reader_fq_domain_name" {
  description = "Hostname to use for the info reader - fully qualified. Must be 'within' the capacity_hosted_zone namespace"
  default = "info-reader"
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

variable "s3_info_reader_object" {
  description = "Object name of ZIP file containing Info Reader version for deployment"
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

variable "capacity_service_api_username" {
  description = "Username accepted by the capacity service"  # Currently the service only recognises one account
  type = "string"
}

variable "capacity_service_api_password" {
  description = "Password accepted by the capacity service"  # Currently the service only recognises one account
  type = "string"
}

variable "capacity_service_cache_ttl_seconds" {
  default = "1800"  # Env var, sent as string
  type = "string"
}

# Info Reader
variable "info_reader_spring_profiles_active" {
  default = "capacity-info-reader-aws"
}

variable "info_reader_dhuftpjob_repeatinterval" {
  default = "300000"
}

#variable "info_reader_dhuftpjob_ftpserver" {
#  type = "}

variable "info_reader_dhuftpjob_ftpport" {
  default = "22"
}

variable "info_reader_dhuftpjob_ftpusername" {
  type = "string"
}

variable "info_reader_dhuftpjob_privatekeyfile" {
  type = "string"
}

variable "info_reader_ekhuftpaijob_repeatinterval" {
  default = "300000"
}

variable "info_reader_ekhuftpaijob_apiurl" {
  default = "Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

# DoS Proxy
variable "dos_service_url" {
  description = "Endpoint URL to forward DoS CheckCapacitySummary SOAP requests on to"
  default = "https://uat.pathwaysdos.nhs.uk/app/api/webservices"
}

variable "dos_service_domain" {
  description = "Endpoint Domain of the DoS"
  default = "uat.pathwaysdos.nhs.uk"
}

variable "dos_proxy_spring_profiles_active" {
  default = "doswrapper-aws-dos-soap-prod-cpsc-rest-aws"
}

#
# Variables for the capacity reader MySQL DB
#

variable "mysql_db_instance" {
  default = "quartz-instance"
}

variable "mysql_db_name" {
  default = "QUARTZ_DB"
}

variable "mysql_username" {
  default = "QuartzRoot"
}

variable "mysql_password" {
  default = "QuartzRoot"
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
