FROM alpine

RUN apk add --update \
	php-pgsql \
	php-pdo \
	php-pdo_pgsql \
	&& rm -rf /var/cache/apk/*

ENTRYPOINT ["php"]
