#!/bin/sh
# Run inside Docker container as it assumes many things.
set -ex
pipenv update --dev
echo "# file generated $(date +"%Y-%m-%dT%H:%M:%SZ" --utc) - see make update-deps" > requirements.txt.lock
pipenv run pip freeze >> requirements.txt.lock
cp Pipfile.lock requirements.txt.lock /output/
