FROM java:openjdk-8

ENV FORWARD_REFERENCE_VERSION="beta-20160414"
ENV BIDIRECTIONAL_REFERENCE_VERSION="beta-20160829"

# See README in that directory.
ADD cockroach-data-${FORWARD_REFERENCE_VERSION} /cockroach-data-reference-7429

# Debian's stock node package doesn't include npm.
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
	apt-get install -y \
	git \
	curl \
	libpq-dev \
	postgresql \
	# acceptance/cli_test.go
	expect \
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

RUN npm install pg@5.0.0

RUN curl -SL https://jdbc.postgresql.org/download/postgresql-9.4.1207.jar > /postgres.jar

RUN git clone --depth 1 -b fatjartests https://github.com/cockroachdb/finagle-postgres.git && \
	cd /finagle-postgres && \
	./sbt assembly && \
	mv target/scala-2.11/finagle-postgres-tests.jar / && \
	cd / && rm -rf /finagle-postgres ~/.ivy2

# Download a reference binary that forward tests can run against.
RUN mkdir /forward-reference-version && \
	curl -SL https://binaries.cockroachdb.com/cockroach-${FORWARD_REFERENCE_VERSION}.linux-amd64.tgz | tar xvz -C /tmp && \
	mv /tmp/cockroach-${FORWARD_REFERENCE_VERSION}*/* /forward-reference-version

# Download a reference binary that bidirectional tests can run against.
RUN mkdir /bidirectional-reference-version && \
	curl -SL https://binaries.cockroachdb.com/cockroach-${BIDIRECTIONAL_REFERENCE_VERSION}.linux-amd64.tgz | tar xvz -C /tmp && \
	mv /tmp/cockroach-${BIDIRECTIONAL_REFERENCE_VERSION}*/* /bidirectional-reference-version

# Install Go compiler, needed for examples-orms tests.
RUN curl https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz -o golang.tar.gz \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV PATH=${PATH}:/usr/local/go/bin
