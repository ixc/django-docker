#!/bin/bash

set -e

PROCESSORS=$(grep -c ^processor /proc/cpuinfo)

exec gunicorn -b 0.0.0.0:8000 -w $((PROCESSORS+1)) -t 30 djangosite.wsgi:application
