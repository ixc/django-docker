#!/bin/bash

set -e

cd "${PROJECT_DIR}"

# Create empty initial MD5 signature.
touch var/migrate.md5

# Migrate.
if python manage.py migrate --list | md5sum -c --status var/migrate.md5; then
    echo 'Migrations are already up to date. Skip.'
else
    echo 'Migrations are out of date. Apply.'
    python manage.py migrate --noinput
    python manage.py migrate --list | md5sum > var/migrate.md5
fi
