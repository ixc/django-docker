#!/bin/bash

echo "# ${0}"

set -e

cd "${PROJECT_DIR}"

exec python manage.py supervisor "$@"
