#Dockers build,ship, run apps in lightweight containers, the containers contain an app and its dependences
#allowing it to run acrross different environments: development, testing, production.

#Containerization, the main feautre of Dockers, allows the container to share the hosts system kernel (OP)
#but the isolation of the containerization allows it to run programs independently inside the environment.

#A Docker image is the snapshot of the environment, it contains the tools needed to run the app: code,
#runtime, libraries and envs, a Docker container is just and instance of this image that is running.

#A Dockerfile is a script to define how the image is built, containing steps on how to set up the environ,
# installing dependencies, copying application files, and defining the command to run the app
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