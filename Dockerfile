FROM java:openjdk-8

# Debian's stock node package doesn't include npm.
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
	apt-get install -y \
	git \
	curl \
	libpq-dev \
	postgresql \
	# C
	gcc \
	libpqtypes-dev \
	# Node
	nodejs \
	# Python
	python-pip \
	python-dev \
	# PHP
	php5-cli \
	php5-pgsql \
	# Ruby
	ruby-pg \
	&& rm -rf /var/lib/apt/lists/*

RUN pip install psycopg2

RUN npm install pg

RUN curl -SL https://jdbc.postgresql.org/download/postgresql-9.4.1207.jar > /postgres.jar

RUN git clone --depth 1 -b fatjartests https://github.com/cockroachdb/finagle-postgres.git && \
	cd /finagle-postgres && \
	./sbt assembly && \
	mv target/scala-2.11/finagle-postgres-tests.jar / && \
	cd / && rm -rf /finagle-postgres ~/.ivy2

ENV FORWARD_REFERENCE_VERSION="beta-20160414"

# Download a reference binary that forward tests can run against.
RUN mkdir /forward-reference-version && \
	curl -SL https://binaries.cockroachdb.com/cockroach-${FORWARD_REFERENCE_VERSION}.linux-amd64.tgz | tar xvz -C /tmp && \
	mv /tmp/cockroach-${FORWARD_REFERENCE_VERSION}*/* /forward-reference-version

ENV BIDIRECTIONAL_REFERENCE_VERSION="beta-20160616"

# Download a reference binary that bidirectional tests can run against.
RUN mkdir /bidirectional-reference-version && \
	curl -SL https://binaries.cockroachdb.com/cockroach-${BIDIRECTIONAL_REFERENCE_VERSION}.linux-amd64.tgz | tar xvz -C /tmp && \
	mv /tmp/cockroach-${BIDIRECTIONAL_REFERENCE_VERSION}*/* /bidirectional-reference-version
