FROM alpine

RUN apk add --update \
	gcc \
	libpq \
	musl-dev \
	postgresql-dev \
	&& rm -rf /var/cache/apk/*
