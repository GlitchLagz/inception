#nginx is a webserver that works with wordpress to host the wordpress site
FROM debian:buster

RUN apt update -yq && \
	apt update -yq && \
	apt install -yq nginx && \
	apt install -yq openssl && \
	apt install -yq curl && \
	mkdir -p /etc/nginx/ssl && \
	mkdir -p /run/nginx && \
	chown -R www-data /var/lib/nginx && \
	rm -rf /etc/nginx/sites-available/default

COPY ./conf/default.conf /etc/nginx/sites-available/default.conf
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./tools/run.sh /tmp/run.sh

RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

EXPOSE 443

ENTRYPOINT [ "sh", "/tmp/run.sh" ]