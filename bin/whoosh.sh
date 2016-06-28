#!/bin/bash

echo "# ${0}"

set -e

cd "${PROJECT_DIR}"

python manage.py rebuild_index --noinput

exec "$@"
