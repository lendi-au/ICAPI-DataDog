#/bin/bash
set -e
printf "\n\n\n--- building image ---\n\n\n"
docker build . \
    --tag lendi-airflow-dependencies \
    --rm \
    -f Dockerfile.dependencies \
    --progress=plain
printf "\n\n\n--- updating dependencies, this can take a while ---\n\n\n"
rm -rf output && mkdir output
docker run \
    --name lendi-airflow-dependencies \
    --rm \
    --mount type=bind,source="$(pwd)/output,target=/output" \
    lendi-airflow-dependencies:latest
cp ./output/Pipfile.lock ./output/requirements.txt.lock ./
