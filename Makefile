NAME = inception
SRCS = ./srcs
COMPOSE = $(SRCS)/docker-compose.yml
DATA_PATH = /home/mmaksimo/data

all: up

# Create directories on host to store volume data
setup:
	@echo "Creating data directories at $(DATA_PATH)..."
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb

# Services up
up: setup
	@echo "Building and starting $(NAME)..."
	docker compose -f $(COMPOSE) up -d --build

# Services down
down:
	@echo "Stopping $(NAME)..."
	docker compose -f $(COMPOSE) down

# Start/Stop specific containers (without removing them)
start:
	docker compose -f $(COMPOSE) start

stop:
	docker compose -f $(COMPOSE) stop

# Clean remove stopped containers and unused images
clean: down
	@echo "Cleaning unused Docker resources..."
	docker system prune -af

# FCLEAN:
# - Stop everything
# - Remove named volumes (down -v)
# - WIPE host data folder (sudo rm -rf)
fclean: down
	@echo "Deep cleaning: Removing all data and volumes..."
	docker system prune -af --volumes
	@echo "Wiping host data directories..."
	@sudo rm -rf $(DATA_PATH)/wordpress/*
	@sudo rm -rf $(DATA_PATH)/mariadb/*

# Rebuild from scratch
re: fclean all

# Quick logs shortcut
logs:
	docker compose -f $(COMPOSE) logs -f

.PHONY: all setup up down start stop clean fclean re logs
