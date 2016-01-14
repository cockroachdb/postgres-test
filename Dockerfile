FROM clojure

RUN lein new jdbc

WORKDIR jdbc

RUN echo '[org.clojure/java.jdbc "0.4.1"]' >> project.clj
RUN echo '[org.postgresql/postgresql "9.4-1204-jdbc42"]' >> project.clj
