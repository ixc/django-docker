#!/bin/bash

echo "# ${0}"

set -e

cd "${PROJECT_DIR}"

touch var/migrate.md5
python manage.py migrate --list > var/migrate.txt

if md5sum -c --status var/migrate.md5; then
    echo 'Migrations are already up to date. Skip.'
else
    echo 'Migrations are out of date. Apply.'
    python manage.py migrate --noinput
    python manage.py migrate --list > var/migrate.txt
    md5sum var/migrate.txt > var/migrate.md5
fi

exec "$@"
