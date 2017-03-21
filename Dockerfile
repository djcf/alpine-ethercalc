FROM mhart/alpine-node:7.7

RUN apk add --update curl && \
	mkdir -p /var/www/html/.pm2; touch /var/www/html/.pm2/pm2.log && \
	adduser -h /var/www/html -s /bin/false -S ethercalc && \
	chown -R ethercalc:nobody /var/www/html && \
	npm install -g ethercalc pm2

USER ethercalc
ENV HOME /var/www/html
EXPOSE 8000
CMD ["sh", "-c", "REDIS_HOST=$REDIS_PORT_6379_TCP_ADDR REDIS_PORT=$REDIS_PORT_6379_TCP_PORT pm2 start -x `which ethercalc` -- --cors && pm2 logs"]
HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1
