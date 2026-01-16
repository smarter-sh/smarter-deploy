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


# ---------------------------------------------------------
# 	Docker Initialization
# ---------------------------------------------------------
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
		python manage.py initialize_waffle && \
		python manage.py create_smarter_admin --username admin --email admin@smarter.sh --password smarter && \
		python manage.py create_user --account_number 3141-5926-5359 --username staff_user --email staff@smarter.sh --password smarter --first_name Smarter --last_name User --admin && \
		python manage.py create_user --account_number 3141-5926-5359 --username customer_user --email customer@smarter.sh --password smarter --first_name Customer --last_name User && \
		python manage.py add_plugin_examples --username admin --verbose && \
		python manage.py verify_dns_configuration && \
		python manage.py deploy_example_chatbot && \
		python manage.py seed_chat_history && \
		python manage.py load_from_github --account_number 3141-5926-5359 --username admin --url https://github.com/smarter-sh/smarter-demo && \
		python manage.py load_from_github --account_number 3141-5926-5359 --username admin --url https://github.com/smarter-sh/examples --repo_version 2 && \
		python manage.py initialize_wagtail && \
		python manage.py initialize_providers && \
		python manage.py apply_manifest --filespec 'smarter/apps/account/data/example-manifests/secret-smarter-test-db.yaml' --username admin && \
		python manage.py update_secret --name smarter_test_user --username admin --value smarter_test_user && \
		python manage.py apply_manifest --filespec 'smarter/apps/plugin/data/sample-connections/smarter-test-db.yaml' --username admin && \
		python manage.py create_stackademy_sql_plugin --db_host sql.lawrencemcdaniel.com --db_name smarter_test_db --db_username smarter_test_user && \
		python manage.py create_stackademy_sql_chatbot" && \
	echo "Docker and Smarter are initialized." && \
	docker ps

run:
	make docker-check && \
	docker-compose pull && \
	docker-compose up


# -------------------------------------------------------------------------
# Helm
# -------------------------------------------------------------------------
helm-update:
	cd helm/charts/smarter && \
	helm dependency update


help:
	@echo '===================================================================='
	@echo 'init           - Initialize MySQL and create the smarter database'
	@echo 'run            - Start all Docker containers using docker-compose'
	@echo 'docker-check   - Verify Docker is installed and running'
	@echo 'docker-shell   - Open a shell in the smarter-app container'
	@echo 'docker-prune   - Remove Docker containers, images, and networks'
	@echo 'helm-update    - Update Helm chart dependencies'
	@echo 'help           - Show this help menu'
	@echo '===================================================================='


