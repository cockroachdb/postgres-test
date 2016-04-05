FROM alpine

RUN apk add --update \
	bash \
	git \
	curl \
	libpq \
	musl-dev \
	postgresql-dev \
	# C \
	gcc \
	# Java \
	openjdk8 \
	# Python \
	py-pip \
	python-dev \
	# Node.js \
	nodejs \
	# PHP \
	php-pgsql \
	php-pdo \
	php-pdo_pgsql \
	# Ruby \
	ruby-pg \
	&& rm -rf /var/cache/apk/*

RUN pip install psycopg2

RUN npm install pg

RUN curl -SL https://jdbc.postgresql.org/download/postgresql-9.4.1207.jar > /postgres.jar

RUN git clone https://github.com/cockroachdb/finagle-postgres.git && cd finagle-postgres && git checkout fatjartests && ./sbt assembly && mv target/scala-2.11/finagle-postgres-tests.jar /
