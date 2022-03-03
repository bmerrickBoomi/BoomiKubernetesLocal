#!/bin/bash

if ! command -v kubectl 2>/dev/null; then 
  kubectl() {
    kubectl.exe "$@"
  }
fi

APATH=kubernetes/addons

# MySQL
kubectl -n addons-mysql-3306 exec -i mysql-3306-0 -- mysqladmin ping -h localhost -u root -ppassword
kubectl -n addons-mysql-3306 exec -i mysql-3306-0 -- mysql -u root -ppassword < $APATH/mysql/datasets/feature_flags.sql
kubectl -n addons-mysql-3306 exec -i mysql-3306-0 -- mysql -u root -ppassword < $APATH/mysql/datasets/mysqlsampledatabase.sql

# Oracle
kubectl -n addons-oracledb-1521 exec -i oracledb-1521-0 -- sqlplus sys/Password123! as sysdba < $APATH/oracledb/datasets/LearningSQL-Oracle-Script.sql

# SQLServer
kubectl -n addons-sqlserver-1433 exec -i sqlserver-1433-0 -- /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Password123! < $APATH/sqlserver/datasets/school-database.sql

# MongoDB
kubectl -n addons-mongodb-27017 exec -i mongodb-27017-0 -- mongoimport --db inventory --collection list --authenticationDatabase admin --username root --password password < $APATH/mongodb/datasets/inventory.json

# Postgres
kubectl -n addons-postgres-5432 exec -i postgres-5432-0 -- pg_restore --dbname=postgresql://postgres:password@localhost:5432/demo < $APATH/postgres/datasets/dvdrental.tar
