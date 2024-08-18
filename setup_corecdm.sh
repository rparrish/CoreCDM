#!/usr/bin/bash

SQL_DIR=SQL/[0-8]*.sql
DUCKDB_FILE=Data/CoreCDM.db

for i in $SQL_DIR; do
   duckdb $DUCKDB_FILE < $i;
   echo "ran $i";
done;
