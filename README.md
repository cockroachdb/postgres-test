# Postgres Test

This is the Docker image used to run the CockroachDB
[acceptance tests](https://github.com/cockroachdb/cockroach/tree/master/acceptance),
which include verification that simple clients in various languages can connect
to and interact with CockroachDB using the Postgres wire protocol -- thus it
includes the tools required to run php, node, java, etc.

[Docker Hub](https://hub.docker.com/r/cockroachdb/postgres-test/) automatically
builds new images from git tags, using the git tag as the Docker tag. By
convention, tags are of the form YYYYMMDD-HHMM.