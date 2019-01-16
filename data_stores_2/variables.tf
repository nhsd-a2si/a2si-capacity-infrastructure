# Note - if you are using a different AWS CLI profile other than the default
# "default", you will need to override this variable in your `local.auto.tfvars`


#
# AWS profiles and regions
#

variable "aws_profile" {
  description = "AWS credentials and config profile to use for acting user"
  default = "default"
}

variable "aws_region" {
  description = "Region within which the resources will be deployed"
  default = "eu-west-2"
}

variable "aws_azs" {
  description = "Availability zones within which the resources will be deployed"
  type = "list"
  default = ["eu-west-2a", "eu-west-2b"]
}


#
# Subnet and VPC Variables
#

variable "vpc_cidr" {
  description = "IP range (CIDR) to use for the VPC"
  default = "10.0.0.0/16"
}

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


#
# Variables for the Elasticache database
#

variable "capacity_service_cache_ttl_seconds" {
  default = "604800"  # Time to live within Redis DB (1 week)
  type = "string"
}

variable "elasticache_node_type" {
  description = "The size and capacity of the node"
  type = "string"
  default = "cache.t2.small"
}

variable "elasticache_cluster_mode_replicas_per_node_group" {
  description = "The number of replicas per node in a cluster group"
  default = 0
}

variable "elasticache_cluster_mode_num_node_groups" {
  description = "The number of node groups in the cluster"
  default = 2
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
  type = "string"
}

variable "postgres_password" {
  type = "string"
}

variable "postgres_instance_class" {
  description = "The size of the server supporting the DB"
  default = "db.t2.small"
}


#
#  Tagging variables
#

variable "nhs_programme_name" {
  default = "a2si"
}

variable "nhs_project_name" {
  default = "capacity and Demand"
}

variable "deployment_version" {
  description = "The version of the deployment so we can be sure that what has been deployed is the correct version"
  type = "string"
}

variable "environment" {
  description = "Short name to differentiate this environment from others"
  default = "a2si-cd-dev"
}
