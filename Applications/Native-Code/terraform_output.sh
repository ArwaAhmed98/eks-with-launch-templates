#!/bin/bash
cd ../..
export REDIS_HOST=$(terraform output -raw redis_address)
export REDIS_PORT=$(terraform output -raw redis_port)
export REDIS_PASSWORD=$(terraform output -raw redis_password)
echo $REDIS_HOST
echo $REDIS_PORT
echo $REDIS_PASSWORD
export RDS_db_username=$(terraform output -raw RDS_db_username)
export RDS_db_password=$(terraform output -raw RDS_db_password)
export RDS_db_name=$(terraform output -raw RDS_db_name)
export RDS_rds_endpoint=$(terraform output -raw RDS_rds_endpoint)
echo $RDS_db_username
echo $RDS_db_password
echo $RDS_db_name
echo $RDS_rds_endpoint
