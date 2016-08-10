FROM java:openjdk-8

# See README in that directory.
ADD cockroach-data-beta-20160414 /cockroach-data-reference-7429

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

RUN npm install pg@5.0.0

RUN curl -SL https://jdbc.postgresql.org/download/postgresql-9.4.1207.jar > /postgres.jar

RUN git clone --depth 1 -b fatjartests https://github.com/cockroachdb/finagle-postgres.git && \
	cd /finagle-postgres && \
	./sbt assembly && \
	mv target/scala-2.11/finagle-postgres-tests.jar / && \
	cd / && rm -rf /finagle-postgres ~/.ivy2
