FROM interaction/base:latest

# Base image for Django projects with Git, Node.js, and PostgreSQL.

# System packages.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        postgresql-client \
        python \
    && rm -rf /var/lib/apt/lists/* \
    # The `apt-get` version of Pip is old, so install it manually.
    && (wget -O - https://bootstrap.pypa.io/get-pip.py | python)

# Node.js.
ENV NODE_VERSION=4.3.2
RUN wget -O - "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" | tar -Jx -C /opt/ -f - \
    && ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/node" /usr/local/bin/ \
    && ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/npm" /usr/local/bin/

# Entrypoint.
ENTRYPOINT ["entrypoint-base.sh", "entrypoint-django.sh"]
CMD ["gunicorn.sh"]

# Source.
COPY . $PROJECT_DIR

# ONBUILD #####################################################################

# Build arguments.
ONBUILD ARG PIP_INDEX_URL=https://pypi.python.org/simple
ONBUILD ARG PROJECT_NAME=djangoproject

# Environment.
ONBUILD ENV PROJECT_NAME=$PROJECT_NAME
ONBUILD ENV PROJECT_DIR=/opt/$PROJECT_NAME
ONBUILD ENV PATH=$PROJECT_DIR/node_modules/.bin:$PATH

# Workdir.
ONBUILD WORKDIR $PROJECT_DIR
