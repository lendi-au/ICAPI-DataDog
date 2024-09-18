#!/bin/bash
# Run inside Docker container as it assumes many things.
set -ex
pipenv update --dev
echo "# file generated $(date +"%Y-%m-%dT%H:%M:%SZ" --utc) - see update-dependencies.sh" > requirements.txt.lock
pipenv run pip freeze >> requirements.txt.lock
cp Pipfile.lock requirements.txt.lock /output/
# ensure output files are owned by same user as bind mount
# - https://stackoverflow.com/questions/26500270/understanding-user-file-ownership-in-docker-how-to-avoid-changing-permissions-o#answer-29584184
chown -R $(stat -c "%u:%g" /output) /output
