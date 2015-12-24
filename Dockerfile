FROM alpine

RUN apk add --update \
	gcc \
	musl-dev \
	postgresql-dev \
	py-pip \
	python-dev \
	&& rm -rf /var/cache/apk/* \
	&& pip install psycopg2

ENTRYPOINT ["python"]
