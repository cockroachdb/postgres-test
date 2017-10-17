FROM java:openjdk-8

# The forward reference version is the oldest version from which we
# support upgrading. The bidirectional reference version is the oldest
# version that we support upgrading from and downgrading to.
ENV FORWARD_REFERENCE_VERSION="beta-20170413"
ENV BIDIRECTIONAL_REFERENCE_VERSION="beta-20170413"

# Debian's stock node package doesn't include npm.
RUN curl -fsSL https://deb.nodesource.com/setup_6.x | bash - && \
	apt-get update -y && \
	apt-get upgrade -y

# Prereqs for dotnet
RUN apt-get install -y \
	curl \
	libunwind8 \
	gettext \
	apt-transport-https

# Register the trusted Microsoft Product Key and Product Feed
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
	mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && \
	sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-jessie-prod jessie main" > /etc/apt/sources.list.d/dotnetdev.list'

# The basics
RUN apt-get update -y && \
  apt-get install -y \
	git \
	libpq-dev \
	postgresql \
	vim

# acceptance/cli_test.go
RUN apt-get install -y \
	expect

# C
RUN apt-get install -y \
	gcc \
	libpqtypes-dev

# Node
RUN apt-get install -y \
	nodejs

# Python
RUN apt-get install -y \
	python-pip \
	python-dev

# PHP
RUN apt-get install -y \
	php5-cli \
	php5-pgsql

# dotnet
RUN apt-get install -y \
	dotnet-sdk-2.0.0 \
	nuget

RUN pip install psycopg2
RUN npm install pg

# Ruby
RUN mkdir ruby-install && \
	curl -fsSL https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz | tar --strip-components=1 -C ruby-install -xz && \
	make -C ruby-install install && \
	ruby-install --system ruby 2.4.0

# Ruby acceptance tests
RUN gem install pg

# Java/Maven

# There doesn't appear to be a good way to install maven via apt-get on the
# base image we're running off of.
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz https://apache.osuosl.org/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz \
  && echo "beb91419245395bd69a4a6edad5ca3ec1a8b64e41457672dc687c173a495f034  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN rm -rf /var/lib/apt/lists/*

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
RUN curl https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz -o golang.tar.gz \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

# Install npgsql and create a local a feed.
RUN mkdir /nuget && \
  echo '<?xml version="1.0" encoding="utf-8"?><configuration><packageSources><add key="local-packages" value="." /></packageSources></configuration>' > /nuget/NuGet.Config && \
	curl -fsSL https://www.nuget.org/api/v2/package/Npgsql/3.2.5 > /nuget/npgsql.3.2.5.nupkg

ENV PATH /usr/local/go/bin:$HOME/dotnet:$PATH
