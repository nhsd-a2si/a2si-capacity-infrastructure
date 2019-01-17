#
# Environment variables for public beta (UAT environment)
#
environment = "a2si-cd-uat"
deployment_version = "0.0.1"

#
# VPCs and Subnets
#
capacity_vpc = "<To be defined by Texas>"

#
# Sizing for Elasticache DB
#
elasticache_node_type = "cache.t2.medium"
elasticache_cluster_mode_replicas_per_node_group = 1
elasticache_cluster_mode_num_node_groups = 2

#
# Parameters for RDS Postgres DB
#
postgres_username = "postmanpat"
postgres_password = "FWr2qN3WTdZJ"
postgres_instance_class = "db.t2.medium"
postgres_allocated_storage = 5
postgres_backup_retention_period = 45
postgres_backup_window = "00:00-00:30"

#
# Parameters for Authentication Dynamo DB Table
#
authentication_db_read_capacity_units = 15
authentication_db_write_capacity_units = 1
