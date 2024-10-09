.PHONY: logs hosts all install build up start down remove re list images delete

all: clean host install create_vol build up

host:
	@if ! grep -q "tpawson.42.fr" /etc/hosts; then \
		sudo sed -i 's|localhost|tpawson.42.fr|g' /etc/hosts; \
		echo "Host file updated"; \
	else \
		echo "Host already set"; \
	fi

install:
	@if [ ! -f /usr/bin/docker-compose ]; then \
		curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose; \
		sudo chown $(USER) /usr/bin/docker-compose; \
		sudo chmod 777 /usr/bin/docker-compose; \
		echo "Docker Compose installed"; \
	else \
		echo "Docker Compose already installed"; \
	fi

build:
	docker compose -f ./srcs/docker-compose.yml build

rm_vol:
	sudo chown -R $(USER) $(HOME)/data
	sudo chmod -R 777 $(HOME)/data
	rm -rf $(HOME)/data

create_vol:
	mkdir -p $(HOME)/data/mysql
	mkdir -p $(HOME)/data/html
	sudo chown -R $(USER) $(HOME)/data
	sudo chmod -R 777 $(HOME)/data

up:
	docker compose -f ./srcs/docker-compose.yml up -d

start:
	docker compose -f ./srcs/docker-compose.yml start

stop:
	docker compose -f ./srcs/docker-compose.yml stop

down:
	@if docker network ls | grep -q "srcs_inception"; then \
		docker compose -f ./srcs/docker-compose.yml down; \
	else \
		echo "Docker network already down"; \
	fi

clean: down
	docker system prune -af || true
	if [ "$$(docker volume ls -q)" != "" ]; then docker volume rm $$(docker volume ls -q); fi || true

remove:
	sudo chown -R $(USER) $(HOME)/data
	sudo chmod -R 777 $(HOME)/data
	rm -rf $(HOME)/data
	docker volume prune -f
	docker volume rm srcs_wordpress
	docker volume rm srcs_mariadb
	docker container prune -f

re: remove delete build up

list:
	docker ps -a
	docker images -a

delete:
	cd srcs && docker compose stop nginx
	cd srcs && docker compose stop wordpress
	cd srcs && docker compose stop mariadb
	docker system prune -a

logs:
	docker compose -f ./srcs/docker-compose.yml logs mariadb
	docker compose -f ./srcs/docker-compose.yml logs wordpress
	docker compose -f ./srcs/docker-compose.yml logs nginx