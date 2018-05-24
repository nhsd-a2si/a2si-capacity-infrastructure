variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_az" {
  default = "eu-west-1a"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "environment" {
  default = "dev"
}

variable "s3_app_versions_bucket" {
  default = "a2si-capacity-eb-versions-markhenwood1"
}

variable "s3_capacity_service_object" {
  description = "Object name of ZIP file containing Capacity Service version for deployment"
  type = "string"
}

variable "s3_dos_wrapper_object" {
  description = "Object name of ZIP file containing DoS Wrapper version for deployment"
  type = "string"
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

variable "nhs_owner" {
  default = "mark.henwood1"
}

variable "nhs_programme_name" {
  default = "a2si"
}

variable "nhs_project_name" {
  default = "capacity"
}
