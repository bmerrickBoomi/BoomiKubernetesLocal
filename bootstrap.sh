#!/bin/bash

if ! command -v kubectl 2>/dev/null; then 
  kubectl() {
    kubectl.exe "$@"
  }
fi

GS="\033[0;32m"
GE="\033[0m"

if [ -z "$1" ];
then
  echo -e "Available Services:$GS"
  echo -e "mysql"
  echo -e "oracledb"
  echo -e "sqlserver"
  echo -e "mongodb"
  echo -e "postgres"
  echo -e "dcp"
  echo -e "vault"
  echo -e "ALL$GE"
  exit
fi

echo "Bootstrapping $1..."
APATH=kubernetes/addons

mysql() {
  echo -e "$GS-- mysql --$GE"

  CHECK="SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'demo' AND table_name = 'feature_flags'"
  if [ $(kubectl -n addons-mysql-3306 exec -i mysql-3306-0 -- mysql --batch -u root -ppassword -e "$CHECK" | sed -n '2 p') -eq 0 ];
  then
    echo -e "$GS -- mysql.feature_flags -- $GE"
    kubectl -n addons-mysql-3306 exec -i mysql-3306-0 -- mysql -u root -ppassword < $APATH/mysql/datasets/feature_flags.sql
  fi

  CHECK='SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = "classicmodels" AND table_name = "customers"'
  if [ $(kubectl -n addons-mysql-3306 exec -i mysql-3306-0 -- mysql --batch -u root -ppassword -e "$CHECK" | sed -n '2 p') -eq 0 ];
  then
    echo -e "$GS -- mysql.classicmodels -- $GE"
    kubectl -n addons-mysql-3306 exec -i mysql-3306-0 -- mysql -u root -ppassword < $APATH/mysql/datasets/mysqlsampledatabase.sql
  fi
}

oracledb() {
  echo -e "$GS-- oracledb --$GE"

  CHECK="Select table_Name from user_Tables Where table_name = 'ACCOUNT';"
  if [ "$(kubectl -n addons-oracledb-1521 exec -i oracledb-1521-0 -- sqlplus -s sys/Password123! as sysdba <<< "$CHECK" | sed -n '2 p')" = "no rows selected" ];
  then
    echo -e "$GS -- oracledb -- $GE"
    kubectl -n addons-oracledb-1521 exec -i oracledb-1521-0 -- sqlplus sys/Password123! as sysdba < $APATH/oracledb/datasets/LearningSQL-Oracle-Script.sql
  fi
}

sqlserver() {
  echo -e "$GS-- sqlserver --$GE"

  CHECK="SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'Person' AND table_catalog = 'school'"
  if [ "$(kubectl -n addons-sqlserver-1433 exec -i sqlserver-1433-0 -- /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Password123! -h-1 -W -w 700 -d school -Q "$CHECK" | sed -n '1 p')" != "1" ];
  then
    echo -e "$GS -- sqlserver.school -- $GE"
    kubectl -n addons-sqlserver-1433 exec -i sqlserver-1433-0 -- /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Password123! < $APATH/sqlserver/datasets/school-database.sql
  fi
}

mongodb() {
  echo -e "$GS-- mongodb --$GE"
  if [ $(kubectl -n addons-mongodb-27017 exec -i mongodb-27017-0 -- mongo --authenticationDatabase admin --username root --password password --eval 'db.getMongo().getDBNames().indexOf("zipcodes")' --quiet) -lt 0 ]; then
    kubectl -n addons-mongodb-27017 exec -i mongodb-27017-0 -- mongoimport --db zipcodes --collection zips --authenticationDatabase admin --username root --password password < $APATH/mongodb/datasets/zips.json
  fi
}

postgres() {
  # Postgres
  #kubectl -n addons-postgres-5432 exec -i postgres-5432-0 -- pg_restore --dbname=postgresql://postgres:password@localhost:5432/demo < $APATH/postgres/datasets/dvdrental.tar
  echo -e "$GS-- postgres --$GE"
}

vault() {
  echo -e "$GS-- vault --$GE"
}

dcp() {
  echo -e "$GS-- dcp --$GE"

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

  ADAPTER_LIST=$(curl -X GET -H "Content-Type: application/json" \
	        -H "Authorization: Bearer $DCP_TOKEN" \
		-s -k https://localhost/datai-api/datastore-adapters/)

  DATA_STORE_LIST=$(curl -X GET -H "Content-Type: application/json" \
    	            -H "Authorization: Bearer $DCP_TOKEN" \
		    -s -k https://localhost/datai-api/datastores/)

  # Data Stores
  dcp_data_store "MySql_5_7"      "MySQL"     "mysql-3306.addons-mysql-3306.svc.cluster.local"         "3306"
  dcp_data_store "MongoDB_3_4"    "MongoDB"   "mongodb-27017.addons-mongodb-27017.svc.cluster.local"   "27017"
  dcp_data_store "PostgreSql_9_3" "Postgres"  "postgres-5432.addons-postgres-5432.svc.cluster.local"   "5432"
  dcp_data_store "SQLServer_15_0" "SQLServer" "sqlserver-1433.addons-sqlserver-1433.svc.cluster.local" "1433"
  dcp_data_store "Oracle_18c"     "Oracle"    "oracledb-1521.addons-oracledb-1521.svc.cluster.local"   "1521"

  DATA_STORE_LIST=$(curl -X GET -H "Content-Type: application/json" \
	            -H "Authorization: Bearer $DCP_TOKEN" \
		    -s -k https://localhost/datai-api/datastores/)

  DATA_SOURCE_LIST=$(curl -X GET -H "Content-Type: application/json" \
                     -H "Authorization: Bearer $DCP_TOKEN" \
                     -s -k https://localhost/datai-api/data-sources/)

  # Data Sources
  dcp_data_source "MySQL"     "root" "password" "classicmodels"
  #dcp_data_source "MongoDB"   ""
  #dcp_data_source "Postgres"  ""
  #dcp_data_source "SQLServer" ""
  #dcp_data_source "Oracle"    ""
}

dcp_data_store() {
  EXISTING_STORE=$(echo "$DATA_STORE_LIST" | jq ".[] | select(.name==\"$2\") | .id")
  if [ -z "$EXISTING_STORE" ];
  then
    echo "Installing Data Store $2..."
    ADAPTER_ID=$(echo "$ADAPTER_LIST" | jq -r ".[] | select(.adapter_base==\"$1\") | .id")
    curl -X POST -H "Content-Type: application/json" \
      -H "Authorization: Bearer $DCP_TOKEN" \
      -d "{\"name\":\"$2\",\"adapter\":$ADAPTER_ID,\"properties\":{\"host\":\"$3\",\"port\":\"$4\"}}" \
      -k https://localhost/datai-api/datastores/

    echo ""
  fi
}

dcp_data_source() {
  EXISTING_SOURCE=$(echo "$DATA_SOURCE_LIST" | jq ".[] | select(.name==\"$1\") | .id")
  if [ -z "$EXISTING_SOURCE" ];
  then
    echo "Installing Data Source $1..."
    STORE_ID=$(echo "$DATA_STORE_LIST" | jq -r ".[] | select(.name==\"$1\") | .id")
    curl -X POST -H "Content-Type: application/json" \
      -H "Authorization: Bearer $DCP_TOKEN" \
      -d "{\"name\":\"$1\",\"datastore\":$STORE_ID,\"description\":\"\",\"properties\":{\"user\":\"$2\",\"password\":\"$3\",\"droppable\":\"False\",\"databasename\":\"$4\"},\"tags\":[]}" \
      -k https://localhost/datai-api/data-sources/

      echo ""
  fi
}

if [ "$1" = "mysql" ];
then
  mysql
elif [ "$1" = "oracledb" ];
then
  oracledb
elif [ "$1" = "sqlserver" ];
then
  sqlserver
elif [ "$1" = "mongodb" ];
then
  mongodb
elif [ "$1" = "postgres" ];
then
  postgres
elif [ "$1" = "vault" ];
then
  vault
elif [ "$1" = "dcp" ];
then
  echo "DCP is not ready, exiting..."
  exit
  dcp $2
elif [ "$1" = "ALL" ];
then
  mysql
  oracledb
  sqlserver
  mongodb
  postgres
  vault
fi

