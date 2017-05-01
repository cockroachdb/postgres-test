FROM java:openjdk-8

# The forward reference version is the oldest version from which we
# support upgrading. The bidirectional reference version is the oldest
# version that we support upgrading from and downgrading to.
ENV FORWARD_REFERENCE_VERSION="beta-20170413"
ENV BIDIRECTIONAL_REFERENCE_VERSION="beta-20170413"

# Debian's stock node package doesn't include npm.
RUN curl -fsSL https://deb.nodesource.com/setup_6.x | bash - && \
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
	php5-pgsql

RUN curl -fsSL -O https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb \
 && dpkg -i dumb-init_1.2.0_amd64.deb && rm dumb-init_1.2.0_amd64.deb

RUN pip install psycopg2
RUN npm install pg

# Ruby
RUN mkdir ruby-install && \
	curl -fsSL https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz | tar --strip-components=1 -C ruby-install -xz && \
	make -C ruby-install install && \
	ruby-install --system ruby 2.4.0

# Ruby acceptance tests
RUN gem install pg

RUN rm -rf /var/lib/apt/lists/*

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

ENV PATH /usr/local/go/bin:$PATH
