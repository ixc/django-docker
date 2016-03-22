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

# Wait for PostgreSQL to become available.
while ! psql -l > /dev/null 2>&1; do
	if [[ $((${COUNT:-0}+1)) -gt 10 ]]; then
		echo 'PostgreSQL still not available. Giving up.'
		exit 1
	fi
	echo 'Waiting for PostgreSQL...'
	sleep 1
done

setup-postgres.sh
migrate.sh

exec "$@"
