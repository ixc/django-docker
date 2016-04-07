#!/bin/sh

# Add features from the `ixc/django-docker` image, without having to build FROM
# it, which would require a complete rebuild of all derivative images for a
# simple script change.

# Usage: wget -O - https://raw.githubusercontent.com/ixc/django-docker/master/bootstrap.sh | sh -s {commit}

COMMIT=${1:-master}

if [[ "$COMMIT" == "master" ]]; then
    >&2 echo "Downloading 'master' version of scripts. You should specify a specific commit for repeatable builds."
fi

# System packages.
apt-get update
apt-get install -y --no-install-recommends \
    postgresql-client \
    python \
    python-dev \
rm -rf /var/lib/apt/lists/*

# Python packages.
wget -O - https://bootstrap.pypa.io/get-pip.py | python
pip install pip-accel[s3] virtualenv

# Node.js
NODE_VERSION=4.3.2
wget -O - "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" | tar -Jx -C /opt/ -f -
ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/node" /usr/local/bin/
ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/npm" /usr/local/bin/

# Scripts.
mkdir -p /opt/django/bin
cd /opt/django/bin
wget "https://raw.githubusercontent.com/ixc/base-docker/${COMMIT}/bin/entrypoint-django.sh"
wget "https://raw.githubusercontent.com/ixc/base-docker/${COMMIT}/bin/migrate.sh"
wget "https://raw.githubusercontent.com/ixc/base-docker/${COMMIT}/bin/setup-local-dev.sh"
wget "https://raw.githubusercontent.com/ixc/base-docker/${COMMIT}/bin/supervisor.sh"
chmod +x /opt/django/bin/*.sh
export PATH=/opt/django/bin:$PATH
