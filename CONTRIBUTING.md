# Contributing to MuniLens

Thank you for your interest in contributing to MuniLens! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Workflow](#development-workflow)
4. [Coding Standards](#coding-standards)
5. [Testing](#testing)
6. [Pull Request Process](#pull-request-process)
7. [Project Structure](#project-structure)

## Code of Conduct

This project adheres to a code of conduct that all contributors are expected to follow. Please be respectful and professional in all interactions.

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Python 3.11+
- Node.js 18+
- Git

### Initial Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/sentimental37/poc.git
   cd poc
   ```

2. Run the setup command:
   ```bash
   make setup
   ```

3. Edit `.env` with your credentials and API keys

4. Start infrastructure services:
   ```bash
   make docker-up
   ```

5. Verify setup:
   ```bash
   curl http://localhost:8000/health
   ```

## Development Workflow

### Branch Naming Convention

- Feature branches: `feature/description`
- Bug fixes: `bugfix/description`
- Hotfixes: `hotfix/description`
- Devin branches: `devin/{timestamp}-description`

### Commit Messages

Follow conventional commit format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Example:
```
feat(ingestion): add EMMA scraper with retry logic

Implemented EMMA document scraper with exponential backoff
and SHA256 integrity checking.

Closes #123
```

### Pre-commit Hooks

Install pre-commit hooks:
```bash
pip install pre-commit
pre-commit install
```

Hooks will automatically run on `git commit` to:
- Format Python code with Black
- Sort imports with isort
- Lint Python with flake8
- Lint TypeScript/JavaScript with ESLint
- Check for trailing whitespace
- Detect private keys

## Coding Standards

### Python

- Follow PEP 8 style guide
- Use type hints for function signatures
- Maximum line length: 120 characters
- Use Black for formatting
- Use isort for import sorting
- Document all public functions and classes with docstrings

Example:
```python
from typing import List, Optional

def extract_metrics(doc_id: str, issuer_id: str) -> Optional[List[dict]]:
    """
    Extract fiscal metrics from a document.
    
    Args:
        doc_id: Document identifier
        issuer_id: Issuer identifier
        
    Returns:
        List of extracted metrics or None if extraction fails
    """
    pass
```

### TypeScript/JavaScript

- Follow Airbnb style guide
- Use TypeScript for type safety
- Use functional components with hooks
- Use Tailwind CSS for styling (no arbitrary values)
- Document complex functions with JSDoc comments

Example:
```typescript
interface Issuer {
  id: string;
  name: string;
  state: string;
}

/**
 * Fetch issuer details from API
 */
async function fetchIssuer(id: string): Promise<Issuer> {
  const response = await axios.get(`/api/v1/issuers/${id}`);
  return response.data;
}
```

### Database

- Use migrations for schema changes (Alembic for PostgreSQL)
- Include rollback logic in all migrations
- Document schema changes in migration files
- Use Cypher migrations for Neo4j schema changes

## Testing

### Python Tests

Run tests:
```bash
cd services/backend
pytest
```

Write tests for:
- All API endpoints
- Business logic functions
- Database operations
- External API integrations

Example:
```python
def test_extract_metrics():
    result = extract_metrics("doc_123", "issuer_456")
    assert result is not None
    assert len(result) > 0
```

### Frontend Tests

Run tests:
```bash
cd services/frontend
npm test
```

Write tests for:
- Components
- Hooks
- Utility functions
- API integrations

## Pull Request Process

1. **Create a feature branch** from `main`

2. **Make your changes** following coding standards

3. **Write tests** for new functionality

4. **Run tests and linters**:
   ```bash
   make test
   make lint
   ```

5. **Commit your changes** with conventional commit messages

6. **Push to your branch**:
   ```bash
   git push origin feature/your-feature
   ```

7. **Create a Pull Request** with:
   - Clear title and description
   - Reference to related issues
   - Screenshots for UI changes
   - Test results

8. **Address review feedback** promptly

9. **Squash commits** if requested

10. **Wait for CI checks** to pass before merging

### PR Review Checklist

- [ ] Code follows project style guidelines
- [ ] Tests added/updated and passing
- [ ] Documentation updated
- [ ] No security vulnerabilities introduced
- [ ] Performance impact considered
- [ ] Database migrations included (if applicable)
- [ ] API changes documented in OpenAPI spec

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
├── notebooks/          # Jupyter notebooks
├── scripts/            # Utility scripts
└── docs/               # Documentation
```

### Service-Specific Guidelines

#### Ingestion Service
- Use Airflow DAGs for scheduling
- Implement retry logic with exponential backoff
- Store raw documents in S3
- Index metadata in PostgreSQL

#### Extraction Service
- Use ensemble approach for table extraction
- Implement validation checks
- Store provenance for all extracted metrics
- Handle OCR errors gracefully

#### Graph Service
- Use Cypher for all Neo4j operations
- Implement idempotent upserts
- Store temporal data on nodes
- Calculate dependency weights accurately

#### Model Service
- Version all models with MLflow
- Generate SHAP values for explainability
- Implement isotonic calibration
- Track model performance metrics

#### Backend API
- Follow REST conventions
- Implement OAuth2/OIDC authentication
- Add rate limiting
- Document all endpoints in OpenAPI

#### Frontend
- Use React Router for navigation
- Implement responsive design
- Use D3.js for visualizations
- Handle loading and error states

## Questions?

If you have questions about contributing, please:
1. Check existing documentation
2. Search closed issues
3. Open a new issue with the `question` label

Thank you for contributing to MuniLens!
