FROM debian:buster

RUN apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt upgrade -yq && \
    apt install mariadb-server mariadb-client yq -yq && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chown -R mysql:mysql /etc/mysql

COPY ./tools/run.sh /tmp/
COPY ./conf/init.sql /tmp/
COPY ./conf/my.cnf /etc/mysql

RUN chown -R mysql:mysql /tmp/ && \
    chown -R mysql:mysql /etc/mysql

USER mysql

ENTRYPOINT ["sh", "/tmp/run.sh"]