#!/bin/bash

set -e

# PostgreSQL.
export PGDATABASE="${PGDATABASE:-${PROJECT_NAME}}"
export PGHOST="${PGHOST:-postgres}"
export PGPORT="${PGPORT:-5432}"
export PGUSER="${PGUSER:-postgres}"

# Python.
export PYTHONHASHSEED=random

# Derive `PGDATABASE` from git branch, if available.
if [[ -d .git ]]; then
    export PGDATABASE="${PGDATABASE}_$(git rev-parse --abbrev-ref HEAD | sed 's/[^0-9A-Za-z]/_/g')"
    echo "Set database name '${PGDATABASE}' from git."
fi

# Wait for linked services to become available.
# dockerize -wait tcp://elasticsearch:9200 -wait "tcp://${PGHOST}:${PGPORT}" -wait tcp://redis:6379

setup-postgres.sh
migrate.sh

exec "$@"
