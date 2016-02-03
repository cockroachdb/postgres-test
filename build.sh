#!/bin/bash

set -eu

tag="$(date +%Y%m%d-%H%M%S)"
docker build -t cockroachdb/postgres-test:${tag} .
