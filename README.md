# ICAPI-DataDog

DEPRECATED.

Instaclustr/NetApp has introduced rate limiting changes to their /v1/monitoring
API endpoint which make it hard to sync metrics from them in this way.

Instead, the prometheus endpoint is preferred to pull / ingest metrics from Instaclustr.

Forked from the Instaclustr repo.

[Instaclustr implementation docs](./instaclustr/README.md)

[DataDog implementation docs](./localdatadog/README.md)

## Development

### Dependencies

    make deps

Update all dependencies to the latest non-major versions:

    make update-deps

Update individual dependencies by modifying `Pipfile` and running `make update-deps`.

### Lint code

    make lint

### Test code

    make test

and for test coverage:

    make coverage

### Building Docker image

    make build

## Environment

See `.env-sample` file for the list of environment variables needed to fetch metrics 
from Instaclustr and ship them to DataDog.

## Run

    make run

## Docker Image Build

SemVer is used to increment the builds.

Images are [pushed to Docker Hub](https://hub.docker.com/r/tedk42/ic2datadog).

The tags in DockerHub will match the Releases of this app.

## References

[Kafka metrics exposed by Instaclustr](https://www.instaclustr.com/support/api-integrations/api-reference/monitoring-api/kafka-metrics-exposed-in-the-monitoring-api/)
For detailed instructions on how to set up see [here](https://support.instaclustr.com/hc/en-us/articles/215566468)
