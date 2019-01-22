# Note - the settings in this file default to the dev environment. The
# default values will need to be overridden in a .tfvars file to support
# a the test, stage and prod environments.

#
# VPC variables and availability zones
#
variable "capacity_vpc" {
  description = "The VPC that the capacity service will be hosted in"
  type = "string"
}

variable "aws_region" {
  description = "The region that the capacity service is hosted in"
  default = "eu-west-2"
}

variable "aws_azs" {
  description = "Availability zones within which the resources will be deployed"
  type = "list"
  default = ["eu-west-2a", "eu-west-2b"]
}

#
# Variables for the Elasticache / Redis database
#
variable "elasticache_authorization_token" {
  description = "The authorization token to be allowed access to the Redis data store"
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
  description = "The name of the database"
  default = "capacity-service-db"
}

variable "postgres_db_name" {
  description = "The schema name of the postgres database that will contain the database tables"
  default = "CapacityService"
}

variable "postgres_username" {
  description = "The username of the postgres database"
  type = "string"
}

variable "postgres_password" {
  description = "The password of the postgres database"
  type = "string"
}

variable "postgres_instance_class" {
  description = "The size of the server supporting the DB"
  default = "db.t2.small"
}

variable "postgres_allocated_storage" {
  description = "The amount of storage in Gigabytes to allocate to the postgres DB"
  default = 2
}

variable "postgres_backup_retention_period" {
  description = "Period to retain backup files"
  default = "30"
}

variable "postgres_backup_window" {
  description = "The time window to commence the daily backup"
  default = "00:00-00:30"
}


#
# Variables for the Authentication (DynamoDB database)
#
variable "authentication_db_read_capacity_units" {
  description = "One read capacity unit represents one strongly consistent read per second, or two eventually consistent reads per second, for items up to 4 KB in size. If you need to read an item that is larger than 4 KB, DynamoDB will need to consume additional read capacity units. The total number of read capacity units required depends on the item size, and whether you want an eventually consistent or strongly consistent read."
  default = "5"
}

variable "authentication_db_write_capacity_units" {
  description = "One write capacity unit represents one write per second for items up to 1 KB in size. If you need to write an item that is larger than 1 KB, DynamoDB will need to consume additional write capacity units. The total number of write capacity units required depends on the item size."
  default = "1"
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
  description = "Name of the environment (i.e. a2si-cd- followed by dev, test, stage, prod)"
  default = "a2si-cd-dev"
}
