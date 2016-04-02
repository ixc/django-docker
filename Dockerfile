FROM interaction/base:latest

# Base image for Django projects with Node.js, PostgreSQL client, and Python.

# System packages.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        python \
        python-dev \
    && rm -rf /var/lib/apt/lists/* \
    # The `apt-get` version of Pip is old, so install it manually.
    && (wget -O - https://bootstrap.pypa.io/get-pip.py | python) \
    && pip install pip-accel[s3] virtualenv

# Node.js.
ENV NODE_VERSION=4.3.2
RUN wget -O - "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" | tar -Jx -C /opt/ -f - \
    && ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/node" /usr/local/bin/ \
    && ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/npm" /usr/local/bin/

# Environment.
ENV PATH=/opt/django/bin:$PATH

# Entrypoint.
ENTRYPOINT ["entrypoint-base.sh", "entrypoint-django.sh"]
CMD ["supervisor.sh"]

# Source.
COPY . /opt/django
