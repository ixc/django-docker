#!/bin/bash

# Setup local development environment.
#
# Create a virtualenv and conditionally install Node.js packages, Bower
# components, and Python packages, when `package.json`, `bower.json` and
# `setup.py` have changed.

set -e

cd "${PROJECT_DIR}/var"

export NODE_MODULES_BIN=${PROJECT_DIR}/var/node_modules/.bin
export PATH="${NODE_MODULES_BIN}:${PROJECT_DIR}/var/venv/bin:$PATH"

# Create empty initial MD5 signatures.
for FILE in bower.json package.json venv
do
    if [[ ! -f "$FILE.md5" ]]; then
        touch "$FILE.md5"
    fi
done

# Node.js packages.
if [[ ! -f node_modules/setup.txt ]] || ! md5sum -c --status package.json.md5; then
    echo 'Node modules are out of date. Install.'
    md5sum ../package.json > package.json.md5
    cp -f ../package.json .
    npm install
    echo 'This file indicates that setup.sh has installed node modules.' > node_modules/setup.txt
else
    echo 'Node modules are already up to date. Skip.'
fi

# Bower components.
if [[ ! -d bower_components ]] || ! md5sum -c --status bower.json.md5; then
    echo 'Bower components are out of date. Install.'
    md5sum ../bower.json > bower.json.md5
    cp -f ../bower.json .
    bower install --allow-root
else
    echo 'Bower components are already up to date. Skip.'
fi

# Python virtualenv.
if [[ ! -d venv ]]; then
    echo 'Python virtualenv does not exist. Create.'
    virtualenv venv
    truncate -s 0 venv.md5
else
    echo 'Python virtualenv already exists. Skip.'
fi

# Python packages.
if ! md5sum -c --status venv.md5; then
    echo 'Python packages are out of date. Install.'
    md5sum ../requirements*.txt ../setup.py > venv.md5
    pip install -r ../requirements.txt -e ..
else
    echo 'Python packages are already up to date. Skip.'
fi
