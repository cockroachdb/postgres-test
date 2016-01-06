FROM debian

RUN apt-get update && apt-get install -y curl default-jdk
RUN curl -SL https://jdbc.postgresql.org/download/postgresql-9.4.1207.jar > /postgres.jar
