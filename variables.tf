variable "aws_region" {
  default = "eu-west-2"
}

variable "aws_azs" {
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for the public subnets"
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "environment" {
  default = "dev"
}

variable "public_domain" {
  description = "Public domain into which FQDN and certificates will be placed (no trailing dot)"
  type = "string"
}

variable "capacity_service_hostname" {
  default = "capacity-service"
}

variable "dos_wrapper_hostname" {
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

variable "s3_dos_wrapper_object" {
  description = "Object name of ZIP file containing DoS Wrapper version for deployment"
  type = "string"
}

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

variable "dos_service_url" {
  default = "https://uat.pathwaysdos.nhs.uk/app/api/webservices"
}

variable "dos_wrapper_spring_profiles_active" {
  default = "doswrapper-aws-dos-soap-prod-cpsc-rest-aws"
}

variable "nhs_owner" {
  description = "Name of the person applying the changes"
  type = "string"
}

variable "nhs_programme_name" {
  default = "a2si"
}

variable "nhs_project_name" {
  default = "capacity"
}
