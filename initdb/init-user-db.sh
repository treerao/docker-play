#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<EOSQL
 create role ppmuser with createdb login;
 create database ppmdb;
 alter database ppmdb owner to ppmuser;
EOSQL

psql -U ppmuser ppmdb </docker-entrypoint-initdb.d/psql.dump
