FROM debian:buster

RUN apt update -yq && \
    apt upgrade -yq && \
    apt install mariadb-server -yq && \
	apt install mariadb-client -yq && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chown -R mysql:mysql /etc/mysql/

COPY ./tools/run.sh /tmp/
COPY ./conf/init.sql /tmp/
COPY ./conf/my.cnf /etc/mysql

RUN chown -R mysql:mysql /tmp/ && \
    chown -R mysql:mysql /etc/mysql

USER mysql

ENTRYPOINT ["sh", "/tmp/run.sh"]