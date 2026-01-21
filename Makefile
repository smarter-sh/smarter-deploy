SHELL := /bin/bash
include .env
export PATH := /usr/local/bin:$(PATH)
export

ifneq ("$(wildcard .env)","")
else
    $(shell cp .env.example .env)
endif

.PHONY: all init run docker-check docker-shell docker-init docker-run docker-prune helm-update help

# Default target executed when no arguments are given to make.
all: help

# run the web application from Docker
# takes around 30 seconds to complete
run:
	make docker-run

# ---------------------------------------------------------
# Docker
# ---------------------------------------------------------
docker-check:
	@docker ps >/dev/null 2>&1 || { echo >&2 "This project requires Docker but it's not running.  Aborting."; exit 1; }

docker-shell:
	make docker-check && \
	docker exec -it smarter-app /bin/bash

docker-prune:
	make docker-check && \
	docker-compose down && \
	docker builder prune -a -f && \
	docker image prune -a -f && \
	rm -rf ./mysql-data && \
	find ./ -name celerybeat-schedule -type f -exec rm -f {} + && \
	docker system prune -a --volumes && \
	docker volume prune -f && \
	docker network prune -f && \
	images=$$(docker images -q) && [ -n "$$images" ] && docker rmi $$images -f || echo "No images to remove"

init:
	echo "Initializing Docker..." && \
	make docker-check && \
	docker-compose pull && \
	docker-compose up -d && \
	echo "Initializing Docker..." && \
	docker exec smarter-mysql bash -c "sleep 20; until echo '\q' | mysql -u smarter -psmarter; do echo 'Waiting for MySQL to be ready...'; sleep 10; done" && \
	docker exec smarter-mysql mysql -u smarter -psmarter -e 'DROP DATABASE IF EXISTS smarter; CREATE DATABASE smarter;' && \
	       docker exec smarter-app bash -c "\
		       python manage.py makemigrations && python manage.py migrate && \
		       python manage.py initialize_platform" && \
	       echo "Docker and Smarter are initialized." && \
	       docker ps

docker-run:
	make docker-check && \
	docker-compose pull && \
	docker-compose up


help:
	@echo '===================================================================='
	@echo 'init           - Initialize MySQL and create the smarter database'
	@echo 'run            - Start all Docker containers using docker-compose'
	@echo 'docker-check   - Verify Docker is installed and running'
	@echo 'docker-shell   - Open a shell in the smarter-app container'
	@echo 'docker-prune   - Remove Docker containers, images, and networks'
	@echo 'help           - Show this help menu'
	@echo '===================================================================='


