FROM alpine

RUN apk add --update \
	curl \
	openjdk7 \
	&& rm -rf /var/cache/apk/*

RUN curl -SL https://jdbc.postgresql.org/download/postgresql-9.4.1207.jar > /postgres.jar
