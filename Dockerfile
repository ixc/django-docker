FROM interaction/base:latest

# Base image for Django projects with Node.js, PostgreSQL client, and Python.

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        python \
        python-dev \
    && rm -rf /var/lib/apt/lists/* \
    && (wget -O - https://bootstrap.pypa.io/get-pip.py | python) \
    && pip install pip-accel[s3] virtualenv

ENV NODE_VERSION=4.3.2
RUN wget -O - "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" | tar -Jx -C /opt/ -f - \
    && ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/node" /usr/local/bin/ \
    && ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/npm" /usr/local/bin/

ENV PATH=/opt/django/bin:$PATH

ENTRYPOINT ["entrypoint-base.sh", "entrypoint-django.sh"]
CMD ["supervisor.sh"]

COPY . /opt/django/
