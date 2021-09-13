#! /bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

cd "$(dirname "$0")"
get_abs_filename() {
  # $1 : relative filename
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

mkdir -p ./postgresdata

POSTGRES_DATA=$(get_abs_filename './postgresdata')

docker run --name odoo_psql \
-e POSTGRES_USER=odoo \
-e POSTGRES_PASSWORD=Aiu5gvRBYt8Y \
-e POSTGRES_DB=postgres \
-e PGDATA=/var/lib/postgresql/data/pgdata \
-v "$POSTGRES_DATA":/var/lib/postgresql/data/pgdata \
-p 5432:5432 -d postgres:13

mkdir -p ./odoo-data

ODOO_DATA=$(get_abs_filename './odoo-data')

docker run --name odoo \
--link odoo_psql:db \
-e USER=odoo \
-e PASSWORD=Aiu5gvRBYt8Y \
-p 8069:8069 -d -t odoo
