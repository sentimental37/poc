# MuniLens: AI-Powered Disclosure Intelligence System for Dynamic Credit Risk Assessment

## Executive Summary

MuniLens is an advanced AI-powered platform that transforms unstructured financial disclosures into actionable credit risk intelligence. The system ingests heterogeneous municipal and corporate financial documents (CAFRs, budgets, audit reports, official statements), extracts quantitative and qualitative fiscal metrics using NLP and LLM models, builds an entity-dependency knowledge graph, and computes explainable, time-variant credit risk scores with full document provenance.

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Architecture](#architecture)
3. [Technology Stack](#technology-stack)
4. [Core Components](#core-components)
5. [Data Flow](#data-flow)
6. [MVP Goals](#mvp-goals)
7. [Implementation Phases](#implementation-phases)
8. [Getting Started](#getting-started)
9. [Project Structure](#project-structure)
10. [Security & Compliance](#security--compliance)

---

## System Overview

### Problem Statement

Conventional municipal and corporate credit analysis relies on:
- Manual review by human analysts
- Periodic rating updates (often quarterly or annually)
- Unstructured, irregular public financial disclosures
- Difficulty integrating heterogeneous data sources

Existing systems (EMMA, DPC Data, Merritt Research) aggregate documents but **do not**:
- Extract comparable financial metrics automatically
- Compute continuous, explainable credit scores
- Track entity relationships and dependencies
- Provide real-time risk monitoring

### Solution

MuniLens provides an **automated, dynamic system** that:
1. **Ingests** heterogeneous, unstructured financial disclosures and news data
2. **Extracts** quantitative and qualitative fiscal variables via NLP/LLM
3. **Links** issuers, obligors, and financed projects in an entity-dependency graph
4. **Computes** explainable, time-variant credit risk scores
5. **Updates** scores continuously as new disclosures arrive
6. **Maintains** full document provenance for auditability

---

## Architecture

### System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        MuniLens Platform                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  Ingestion   │  │  Extraction  │  │    Graph     │          │
│  │   Service    │→ │   Service    │→ │   Service    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│         │                  │                  │                  │
│         ↓                  ↓                  ↓                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Document   │  │   Feature    │  │    Neo4j     │          │
│  │   Storage    │  │  Extraction  │  │  Knowledge   │          │
│  │   (S3/PG)    │  │   (LLM)      │  │    Graph     │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                           │                  │                  │
│                           ↓                  ↓                  │
│                    ┌──────────────────────────┐                 │
│                    │    Model Service         │                 │
│                    │  - Risk Scoring Engine   │                 │
│                    │  - Explainability Layer  │                 │
│                    │  - ML Pipeline           │                 │
│                    └──────────────────────────┘                 │
│                              │                                   │
│                              ↓                                   │
│                    ┌──────────────────────────┐                 │
│                    │   API/UI Service         │                 │
│                    │  - FastAPI Backend       │                 │
│                    │  - React + D3 Frontend   │                 │
│                    └──────────────────────────┘                 │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Five Primary Microservices

1. **Ingestion Service** - Document scraping, storage, and classification
2. **Extraction Service** - PDF parsing + LLM-based table/metric extraction
3. **Graph Service** - Neo4j knowledge graph maintaining entity relationships
4. **Model Service** - ML pipeline generating scores and anomaly alerts
5. **API/UI Service** - FastAPI backend + React/D3 frontend for visualization

---

## Technology Stack

| Component           | Technology                                          |
|---------------------|-----------------------------------------------------|
| **Orchestration**   | Apache Airflow                                      |
| **OCR**             | Tesseract / AWS Textract                            |
| **NLP/LLM**         | OpenAI GPT-4 / HuggingFace fine-tuned models        |
| **Storage**         | PostgreSQL (structured) + S3 (raw documents)        |
| **Graph Database**  | Neo4j                                               |
| **ML/Modeling**     | Python (PyTorch, XGBoost, scikit-learn)             |
| **API**             | FastAPI                                             |
| **Frontend**        | React + D3.js                                       |
| **Deployment**      | Azure / AWS GovCloud (Kubernetes)                   |
| **Message Queue**   | Redis / RabbitMQ                                    |
| **Monitoring**      | Prometheus + Grafana                                |

---

## Core Components

### 1. Data Ingestion Subsystem

**Sources:**
- EMMA (Electronic Municipal Market Access)
- SEC EDGAR (corporate/municipal filings)
- State and local government portals
- Issuer websites
- Rating agency reports (Moody's, S&P, Fitch)
- Local news feeds

**Preprocessing:**
- OCR of scanned PDFs
- Document classification by type:
  - Financial statements (CAFR, audit reports)
  - Budget documents
  - Management Discussion & Analysis (MD&A)
  - Official statements
  - Continuing disclosure filings
- Document chunking for LLM processing

### 2. Extraction Engine

**LLM-Based Extraction:**
- Fine-tuned models identify and extract fiscal metrics:
  - Revenues (by source: tax, fees, grants)
  - Expenditures (by category: operations, capital, debt service)
  - Debt service coverage ratios
  - Pension obligations and funded status
  - Fund balances and liquidity metrics
  
**Validation Layer:**
- Arithmetic consistency checks (assets = liabilities + fund balance)
- Cross-document reconciliation
- Historical trend validation

**Qualitative Analysis:**
- Text vectorization for sentiment analysis
- Topic embeddings from MD&A sections
- Risk factor extraction from auditor notes

### 3. Entity-Dependency Graph

**Graph Schema:**

```
Entities (Nodes):
- Issuer (municipality, agency, corporation)
- Obligor (entity responsible for debt payment)
- Project (infrastructure, facility)
- Security (bonds identified by CUSIP)
- Rating (credit rating from agencies)

Relationships (Edges):
- GUARANTEES
- OWNS
- OPERATES
- FUNDS
- ISSUES
- SECURES
- DEPENDS_ON
```

**Temporal Attributes:**
- Each node stores time-series fiscal data
- Edge weights represent financial exposure amounts
- Historical snapshots for trend analysis

### 4. Risk Scoring Engine

**Feature Engineering:**
- Quantitative ratios (debt-to-revenue, liquidity, coverage)
- Peer comparisons (percentile rankings)
- Historical deltas and volatility measures
- Graph centrality and propagation features

**Model Components:**
- **XGBoost/Random Forest** for structured financial ratios
- **Neural networks** for embedding qualitative text features
- **Graph Neural Networks (GNN)** for relationship propagation
- **Ensemble model** combining all feature sets

**Dynamic Scoring:**
- Continuous updates as new disclosures arrive
- Confidence bands and uncertainty quantification
- Trend indicators (improving, stable, deteriorating)

**Reinforcement Learning:**
- Model weights updated based on realized events:
  - Rating changes
  - Default events
  - Market price movements

### 5. Explainability Layer

**Capabilities:**
- Human-readable explanations for each score change
- Citation of specific disclosure sections influencing scores
- Variable importance rankings (SHAP values)
- Full document provenance chain
- Audit trail for compliance and model-risk governance

**Output Example:**
```
Credit Score Change: 72 → 68 (↓4 points)
Primary Drivers:
1. Pension funded ratio decreased from 78% to 72% (Source: CAFR 2023, Note 10, p. 47)
2. Debt service coverage fell to 1.1x from 1.3x (Source: Budget FY2024, Schedule A)
3. Management noted revenue shortfall of $2.3M (Source: MD&A, p. 12)
```

---

## Data Flow

```
1. Source Documents
   ↓
2. OCR & Classification (Ingestion Service)
   ↓
3. Metric Extraction (Extraction Service)
   - Table parsing
   - Text analysis
   - Validation
   ↓
4. Graph Update (Graph Service)
   - Entity recognition
   - Relationship mapping
   - Temporal storage
   ↓
5. Feature Engineering (Model Service)
   - Ratio computation
   - Embedding generation
   - Graph features
   ↓
6. Model Compute (Model Service)
   - Score prediction
   - Confidence estimation
   - Explainability generation
   ↓
7. Score Storage (PostgreSQL)
   ↓
8. API/UI (FastAPI + React)
   - REST endpoints
   - WebSocket updates
   - Dashboard visualization
```

---

## MVP Goals (First 90 Days)

### Data Coverage
- **100 municipal issuers** across 10 states
- **2 years of historical data** per issuer
- Document types: CAFRs, budgets, official statements

### Extraction Accuracy
- **≥90% accuracy** in extracting 10 key fiscal ratios
- **≥85% success rate** in table parsing from PDFs
- **Validation** against human-annotated ground truth

### Predictive Performance
- **≥70% precision** in predicting direction of next rating change
- **≥60% recall** for detecting credit deterioration events
- Benchmark against rating agency changes (6-month horizon)

### System Capabilities
- **Daily score updates** for all tracked issuers
- **<5 minute latency** from document ingestion to score update
- **Interactive dashboard** showing:
  - Credit risk heatmap by geography
  - Issuer detail pages with trend charts
  - Document provenance viewer
  - Peer comparison tables

### Technical Metrics
- **99.5% uptime** for API services
- **Full audit trail** for all score changes
- **API response time** <200ms (p95)

---

## Implementation Phases

### Phase 1: Foundation & Data Ingestion (Weeks 1-3)

**Deliverables:**
- [ ] EMMA scraper implementation
- [ ] SEC EDGAR integration
- [ ] Document storage infrastructure (S3 + PostgreSQL)
- [ ] Document classification model
- [ ] Ingestion API endpoints

**Technologies:**
- Puppeteer/Playwright for web scraping
- AWS S3 for document storage
- PostgreSQL for metadata
- FastAPI for orchestration

### Phase 2: Extraction Engine (Weeks 4-6)

**Deliverables:**
- [ ] PDF parsing pipeline (OCR integration)
- [ ] Table extraction from financial statements
- [ ] LLM-based metric extraction
- [ ] Validation and consistency checker
- [ ] Extraction API and database schema

**Technologies:**
- AWS Textract / Tesseract
- OpenAI GPT-4 / HuggingFace Transformers
- Custom fine-tuning on financial documents
- PostgreSQL for extracted metrics

### Phase 3: Entity-Dependency Graph (Weeks 7-9)

**Deliverables:**
- [ ] Neo4j deployment and schema design
- [ ] Entity recognition from documents
- [ ] Relationship extraction and mapping
- [ ] Graph query API
- [ ] Time-series attribute storage

**Technologies:**
- Neo4j Graph Database
- spaCy/Transformers for entity recognition
- FastAPI graph query endpoints
- Cypher query language

### Phase 4: Risk Scoring & ML Pipeline (Weeks 10-11)

**Deliverables:**
- [ ] Feature engineering pipeline
- [ ] Model training infrastructure
- [ ] XGBoost/PyTorch model implementation
- [ ] Explainability layer (SHAP integration)
- [ ] Model versioning and monitoring

**Technologies:**
- scikit-learn, XGBoost, PyTorch
- SHAP for explainability
- MLflow for experiment tracking
- Airflow for pipeline orchestration

### Phase 5: API & Visualization (Week 12)

**Deliverables:**
- [ ] FastAPI backend with full REST endpoints
- [ ] WebSocket support for real-time updates
- [ ] React frontend with D3.js visualizations
- [ ] Credit risk heatmap
- [ ] Issuer detail pages
- [ ] Document provenance viewer

**Technologies:**
- FastAPI + Pydantic
- React + TypeScript
- D3.js for charts
- TailwindCSS for styling

---

## Getting Started

### Prerequisites

- **Docker** and **Docker Compose**
- **Python 3.11+**
- **Node.js 18+**
- **PostgreSQL 15+**
- **Neo4j 5+**
- **AWS Account** (for S3 and Textract)

### Local Development Setup

1. **Clone the repository:**
```bash
git clone https://github.com/DeCloakAi/decloak-mvp.git
cd decloak-mvp/fin/poc
```

2. **Set up environment variables:**
```bash
cp .env.example .env
# Edit .env with your credentials
```

3. **Start infrastructure services:**
```bash
docker-compose up -d postgres neo4j redis
```

4. **Install Python dependencies:**
```bash
cd services/backend
pip install -r requirements.txt
```

5. **Install Node.js dependencies:**
```bash
cd services/frontend
npm install
```

6. **Run database migrations:**
```bash
cd services/backend
alembic upgrade head
```

7. **Start development servers:**
```bash
# Terminal 1 - Backend
cd services/backend
uvicorn main:app --reload

# Terminal 2 - Frontend
cd services/frontend
npm run dev
```

8. **Access the application:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

---

## Project Structure

```
fin/poc/
├── README.md                          # This file
├── docker-compose.yml                 # Infrastructure services
├── .env.example                       # Environment variables template
│
├── services/
│   ├── ingestion/                     # Document ingestion service
│   │   ├── scrapers/
│   │   │   ├── emma_scraper.py
│   │   │   ├── edgar_scraper.py
│   │   │   └── news_scraper.py
│   │   ├── classifiers/
│   │   │   └── document_classifier.py
│   │   └── api/
│   │       └── ingestion_api.py
│   │
│   ├── extraction/                    # Metric extraction service
│   │   ├── parsers/
│   │   │   ├── pdf_parser.py
│   │   │   ├── table_extractor.py
│   │   │   └── ocr_handler.py
│   │   ├── extractors/
│   │   │   ├── llm_extractor.py
│   │   │   ├── fiscal_metrics.py
│   │   │   └── qualitative_analyzer.py
│   │   └── validators/
│   │       └── consistency_checker.py
│   │
│   ├── graph/                         # Neo4j graph service
│   │   ├── models/
│   │   │   ├── entities.py
│   │   │   └── relationships.py
│   │   ├── queries/
│   │   │   └── cypher_queries.py
│   │   └── api/
│   │       └── graph_api.py
│   │
│   ├── model/                         # ML/risk scoring service
│   │   ├── features/
│   │   │   ├── feature_engineering.py
│   │   │   └── graph_features.py
│   │   ├── models/
│   │   │   ├── xgboost_model.py
│   │   │   ├── neural_model.py
│   │   │   └── ensemble.py
│   │   ├── explainability/
│   │   │   ├── shap_explainer.py
│   │   │   └── provenance_tracker.py
│   │   └── api/
│   │       └── scoring_api.py
│   │
│   ├── backend/                       # Main FastAPI application
│   │   ├── main.py
│   │   ├── routers/
│   │   ├── schemas/
│   │   ├── database/
│   │   └── requirements.txt
│   │   
│   └── frontend/                      # React + D3.js frontend
│       ├── src/
│       │   ├── components/
│       │   ├── pages/
│       │   ├── hooks/
│       │   └── utils/
│       ├── package.json
│       └── tsconfig.json
│   
├── data/                              # Local data directory
│   ├── raw/                           # Raw documents
│   ├── processed/                     # Extracted metrics
│   └── models/                        # Trained model artifacts
│   
├── notebooks/                         # Jupyter notebooks for exploration
│   ├── data_exploration.ipynb
│   ├── model_training.ipynb
│   └── evaluation.ipynb
│   
├── scripts/                           # Utility scripts
│   ├── seed_data.py
│   ├── train_model.py
│   └── evaluate_model.py
│   
├── airflow/                           # Airflow DAGs
│   └── dags/
│       ├── ingestion_pipeline.py
│       ├── extraction_pipeline.py
│       └── scoring_pipeline.py
│   
└── tests/                             # Test suites
    ├── test_ingestion.py
    ├── test_extraction.py
    ├── test_graph.py
    └── test_scoring.py
```

---

## Security & Compliance

### Data Security
- All data **encrypted in transit** (TLS 1.3)
- All data **encrypted at rest** (AES-256)
- Role-based access control (RBAC)
- API authentication via JWT tokens

### Audit & Compliance
- Full audit logs of:
  - Model inputs and outputs
  - Score changes and drivers
  - User access and queries
- Configurable retention policies
- MSRB Rule G-37 compliance support
- SEC recordkeeping requirements

### Privacy
- No PII collection
- Public data sources only
- GDPR-compliant data handling

---

## License

This project is proprietary and confidential. All rights reserved.

---

## Contact

**Project Team:**
- Technical Lead: [Your Name]
- Product Manager: [PM Name]
- Data Science Lead: [DS Lead Name]

**Repository:** https://github.com/DeCloakAi/decloak-mvp

**Documentation:** [Link to full technical docs]

---

## Appendix: Key Metrics Extracted

### Quantitative Fiscal Metrics (Target: 10 Core Ratios)

1. **Debt Service Coverage Ratio** = (Revenues - Operating Expenses) / Debt Service
2. **Debt-to-Revenue Ratio** = Total Debt / Total Revenues
3. **Liquidity Ratio** = (Cash + Investments) / Current Liabilities
4. **Operating Margin** = (Operating Revenues - Operating Expenses) / Operating Revenues
5. **Pension Funded Ratio** = Pension Assets / Pension Liabilities
6. **OPEB Funded Ratio** = OPEB Assets / OPEB Liabilities
7. **Fund Balance as % of Expenditures** = Unrestricted Fund Balance / Total Expenditures
8. **Revenue Diversity (Herfindahl Index)** = Σ(Revenue Source Share²)
9. **Capital Expenditure Ratio** = Capital Outlays / Total Expenditures
10. **Intergovernmental Revenue Dependence** = Intergovernmental Revenue / Total Revenue

### Qualitative Features

- Management tone (sentiment analysis)
- Risk factor mentions
- Auditor qualifications or concerns
- Governance quality indicators
- Economic base diversity

---

**Last Updated:** 2025-01-14
**Version:** 1.0.0 (MVP)
