# MuniLens Development Setup

This document provides quick start instructions for setting up the MuniLens development environment.

## Quick Start

### 1. Prerequisites

Ensure you have the following installed:
- Docker and Docker Compose
- Python 3.11+
- Node.js 18+
- Make

### 2. Initial Setup

```bash
# Clone the repository
git clone https://github.com/sentimental37/poc.git
cd poc

# Run setup (creates .env, installs dependencies, starts infrastructure)
make setup
```

### 3. Configure Environment

Edit `.env` with your credentials:
```bash
# Required: Database passwords
POSTGRES_PASSWORD=your_secure_password
NEO4J_PASSWORD=your_secure_password
REDIS_PASSWORD=your_secure_password

# Required: API keys
OPENAI_API_KEY=your_openai_key
AWS_ACCESS_KEY_ID=your_aws_key
AWS_SECRET_ACCESS_KEY=your_aws_secret

# Optional: External data sources
EMMA_API_KEY=your_emma_key
CENSUS_API_KEY=your_census_key
FRED_API_KEY=your_fred_key
```

### 4. Start Services

```bash
# Start infrastructure (PostgreSQL, Neo4j, Redis)
make docker-up

# In separate terminals:
# Terminal 1 - Backend
make backend-dev

# Terminal 2 - Frontend
make frontend-dev
```

### 5. Verify Setup

- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs
- Frontend: http://localhost:3000
- Neo4j Browser: http://localhost:7474
- PostgreSQL: localhost:5432

## Development Workflow

### Running Tests

```bash
# Run all tests
make test

# Run backend tests only
cd services/backend && pytest

# Run frontend tests only
cd services/frontend && npm test
```

### Code Quality

```bash
# Run linters
make lint

# Format code
make format
```

### Database Management

```bash
# Initialize PostgreSQL schema
docker exec -i munilens-postgres psql -U munilens -d munilens < scripts/init_db.sql

# Initialize Neo4j schema
docker exec -i munilens-neo4j cypher-shell -u neo4j -p your_password < scripts/init_neo4j.cypher
```

### Stopping Services

```bash
# Stop infrastructure
make docker-down

# Clean build artifacts
make clean
```

## Project Structure

```
poc/
├── services/
│   ├── ingestion/      # Document ingestion service
│   ├── extraction/     # Metric extraction service
│   ├── graph/          # Neo4j graph service
│   ├── model/          # ML scoring service
│   ├── backend/        # FastAPI backend
│   └── frontend/       # React frontend
├── data/               # Local data storage
├── scripts/            # Utility scripts
├── docker-compose.yml  # Infrastructure services
├── Makefile            # Common commands
└── .env                # Environment variables
```

## Troubleshooting

### Docker services won't start

```bash
# Check if ports are already in use
lsof -i :5432  # PostgreSQL
lsof -i :7474  # Neo4j HTTP
lsof -i :7687  # Neo4j Bolt
lsof -i :6379  # Redis

# Stop conflicting services or change ports in docker-compose.yml
```

### Backend won't connect to databases

```bash
# Verify services are running
docker ps

# Check service health
docker-compose ps

# View logs
make docker-logs
```

### Frontend build errors

```bash
# Clear node_modules and reinstall
cd services/frontend
rm -rf node_modules package-lock.json
npm install
```

## Next Steps

1. Review [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines
2. Check [README.md](README.md) for system architecture
3. Review [techdetails](techdetails) for implementation specifications
4. Start with Phase 1: Data Ingestion (FGQ-1)

## Getting Help

- Check existing documentation
- Search closed issues on GitHub
- Open a new issue with the `question` label
