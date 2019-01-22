#
# Environment variables for public beta (testing environment)
#
environment = "a2si-cd-test"
deployment_version = "0.0.1"

#
# VPCs and Subnets
#
capacity_vpc = "<To be defined by Texas>"

#
# Parameters for Elasticache DB
#
elasticache_authorization_token = "Hyyu2eehlojhbs82-622ekPjaQui82GZ"
elasticache_node_type = "cache.t2.small"
elasticache_cluster_mode_replicas_per_node_group = 0
elasticache_cluster_mode_num_node_groups = 2

#
# Parameters for RDS Postgres DB
#
postgres_username = "<USERNAME>"
postgres_password = "<PASSWORD>"
postgres_instance_class = "db.t2.small"
postgres_allocated_storage = 2
postgres_backup_retention_period = 30
postgres_backup_window = "00:00-00:30"

#
# Parameters for Authentication Dynamo DB Table
#
authentication_db_read_capacity_units = 5
authentication_db_write_capacity_units = 1
