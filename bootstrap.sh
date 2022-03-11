#!/bin/bash

if ! command -v kubectl 2>/dev/null; then 
  kubectl() {
    kubectl.exe "$@"
  }
fi

if [ -z "$1" ];
then
  echo "Available Services:"
  echo -e "\033[0;32mmysql"
  echo -e "oracledb"
  echo -e "sqlserver"
  echo -e "mongodb"
  echo -e "postgres"
  echo -e "dcp"
  echo -e "--ALL\033[0m"
  exit
fi

echo "Bootstrapping $1..."
APATH=kubernetes/addons

mysql() {
  # MySQL
  kubectl -n addons-mysql-3306 exec -i mysql-3306-0 -- mysqladmin ping -h localhost -u root -ppassword
  kubectl -n addons-mysql-3306 exec -i mysql-3306-0 -- mysql -u root -ppassword < $APATH/mysql/datasets/feature_flags.sql
  kubectl -n addons-mysql-3306 exec -i mysql-3306-0 -- mysql -u root -ppassword < $APATH/mysql/datasets/mysqlsampledatabase.sql
}

oracledb() {
  # Oracle
  kubectl -n addons-oracledb-1521 exec -i oracledb-1521-0 -- sqlplus sys/Password123! as sysdba < $APATH/oracledb/datasets/LearningSQL-Oracle-Script.sql
}

sqlserver() {
  # SQLServer
  kubectl -n addons-sqlserver-1433 exec -i sqlserver-1433-0 -- /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Password123! < $APATH/sqlserver/datasets/school-database.sql
}

mongodb() {
  # MongoDB
  kubectl -n addons-mongodb-27017 exec -i mongodb-27017-0 -- mongoimport --db inventory --collection list --authenticationDatabase admin --username root --password password < $APATH/mongodb/datasets/inventory.json
}

postgres() {
  # Postgres
  kubectl -n addons-postgres-5432 exec -i postgres-5432-0 -- pg_restore --dbname=postgresql://postgres:password@localhost:5432/demo < $APATH/postgres/datasets/dvdrental.tar
}

dcp() {
  if [ -z "$1" ];
  then
    echo -e "\033[0;31mDCP password is required\033[0m"
    return
  fi

  DCP_TOKEN=$(curl -X POST -H "Content-Type: application/json" \
    -d "{\"username\": \"unifi\", \"password\": \"$1\"}" \
    -s -k https://localhost/datai-api/get-jwt/ | jq --raw-output .token)

  ADAPTERS=("AtomSphere" "MasterDataHub" "MongoDB_3_4" "MySql_5_7" "PostgreSql_9_3" "SQLServer_15_0" "Oracle_18c")

  for a in ${ADAPTERS[@]}; do
    echo "Installing $a..."
    curl -X POST -H "Content-Type: application/json" \
      -H "Authorization: Bearer $DCP_TOKEN" \
      -d "{\"adapter_name\": \"$a\"}" \
      -k https://localhost/datai-api/install-adapter/

      echo ""
  done
}

if [ "$1" = "mysql" ];
then
  echo "mysql"
elif [ "$1" = "oracledb" ];
then
  echo "oracledb"
elif [ "$1" = "sqlserver" ];
then
  echo "sqlserver"
elif [ "$1" = "mongodb" ];
then
  echo "mongodb"
elif [ "$1" = "postgres" ];
then
  echo "postgres"
elif [ "$1" = "dcp" ];
then
  dcp $2
elif [ "$1" = "--ALL" ];
then
  echo "--ALL"
fi

