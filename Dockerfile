FROM alpine

RUN apk add --update \
	php-pgsql \
	&& rm -rf /var/cache/apk/*

ENTRYPOINT ["php"]
