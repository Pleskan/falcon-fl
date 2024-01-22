# REQUIRED SECTION
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(ROOT_DIR)/.mk-lib/common.mk
# END OF REQUIRED SECTION

.PHONY: help dependencies up start stop restart status ps clean

dependencies: check-dependencies ## Check dependencies

up: ## Start all or c=<name> containers in foreground
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) -f $(DOCKER_COMPOSE_OVERRIDE_FILE) up $(c)

start: ## Start all or c=<name> containers in background
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) -f $(DOCKER_COMPOSE_OVERRIDE_FILE) up --remove-orphans -d $(c)

stop: ## Stop all or c=<name> containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) -f $(DOCKER_COMPOSE_OVERRIDE_FILE) stop $(c)

restart: ## Restart all or c=<name> containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) -f $(DOCKER_COMPOSE_OVERRIDE_FILE) stop $(c)
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) -f $(DOCKER_COMPOSE_OVERRIDE_FILE) up -d $(c)
build:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) -f $(DOCKER_COMPOSE_OVERRIDE_FILE) build $(c)
    
logs: ## Show logs for all or c=<name> containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) -f $(DOCKER_COMPOSE_OVERRIDE_FILE) logs --tail=100 -f $(c)

status: ## Show status of containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) -f $(DOCKER_COMPOSE_OVERRIDE_FILE) ps

ps: status ## Alias of status

migrations:
	@$(DOCKER_COMPOSE) exec -it  php php artisan migrate
php-test:
	@$(DOCKER_COMPOSE) exec -it php /bin/bash	

migrations-rollback:
	@$(DOCKER_COMPOSE) exec -it php php artisan migrate:reset

composer-install-deps:
	@$(DOCKER_COMPOSE) exec -it php su - www-data -c 'cd /app && composer install'


clean: confirm ## Clean all data
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE)  -f $(DOCKER_COMPOSE_OVERRIDE_FILE) down
clean-all:
	@$(DOCKER_BINARY) system prune -a --volumes

