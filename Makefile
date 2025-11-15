.PHONY: help setup install test lint format clean docker-up docker-down docker-logs

help:
	@echo "MuniLens - Available Commands"
	@echo "=============================="
	@echo "setup          - Initial project setup"
	@echo "install        - Install all dependencies"
	@echo "test           - Run all tests"
	@echo "lint           - Run linters"
	@echo "format         - Format code"
	@echo "clean          - Clean build artifacts"
	@echo "docker-up      - Start infrastructure services"
	@echo "docker-down    - Stop infrastructure services"
	@echo "docker-logs    - View infrastructure logs"
	@echo "backend-dev    - Start backend development server"
	@echo "frontend-dev   - Start frontend development server"

setup:
	@echo "Setting up MuniLens development environment..."
	cp .env.example .env
	@echo "Please edit .env with your credentials"
	make install
	make docker-up

install:
	@echo "Installing Python dependencies..."
	cd services/ingestion && pip install -r requirements.txt
	cd services/extraction && pip install -r requirements.txt
	cd services/graph && pip install -r requirements.txt
	cd services/model && pip install -r requirements.txt
	cd services/backend && pip install -r requirements.txt
	@echo "Installing frontend dependencies..."
	cd services/frontend && npm install

test:
	@echo "Running tests..."
	cd services/backend && pytest
	cd services/frontend && npm test

lint:
	@echo "Running linters..."
	cd services/backend && pylint **/*.py || true
	cd services/frontend && npm run lint

format:
	@echo "Formatting code..."
	cd services/backend && black . && isort .
	cd services/frontend && npm run format || true

clean:
	@echo "Cleaning build artifacts..."
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "node_modules" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "dist" -exec rm -rf {} + 2>/dev/null || true

docker-up:
	@echo "Starting infrastructure services..."
	docker-compose up -d
	@echo "Waiting for services to be ready..."
	sleep 10
	@echo "Services started successfully"

docker-down:
	@echo "Stopping infrastructure services..."
	docker-compose down

docker-logs:
	docker-compose logs -f

backend-dev:
	@echo "Starting backend development server..."
	cd services/backend && python main.py

frontend-dev:
	@echo "Starting frontend development server..."
	cd services/frontend && npm run dev
