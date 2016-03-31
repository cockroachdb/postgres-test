FROM alpine

RUN apk add --update \
	curl \
	libpq \
	musl-dev \
	postgresql-dev \
	# C \
	gcc \
	# Java \
	openjdk7 \
	# Python \
	py-pip \
	python-dev \
	# PHP \
	php-pgsql \
	php-pdo \
	php-pdo_pgsql \
	# Ruby \
	ruby-pg \
	&& rm -rf /var/cache/apk/*

RUN pip install psycopg2

RUN curl -SL https://jdbc.postgresql.org/download/postgresql-9.4.1207.jar > /postgres.jar
