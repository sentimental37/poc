
CREATE TABLE IF NOT EXISTS documents (
    doc_id SERIAL PRIMARY KEY,
    issuer_id VARCHAR(255),
    source_url TEXT,
    doc_type VARCHAR(100),
    fiscal_year INTEGER,
    sha256 VARCHAR(64) UNIQUE NOT NULL,
    stored_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ocr_status VARCHAR(50) DEFAULT 'pending',
    meta JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_documents_issuer_id ON documents(issuer_id);
CREATE INDEX idx_documents_doc_type ON documents(doc_type);
CREATE INDEX idx_documents_fiscal_year ON documents(fiscal_year);
CREATE INDEX idx_documents_sha256 ON documents(sha256);

CREATE TABLE IF NOT EXISTS metrics (
    metric_id SERIAL PRIMARY KEY,
    issuer_id VARCHAR(255) NOT NULL,
    as_of DATE NOT NULL,
    dsc DECIMAL(10, 4),
    fund_balance_ratio DECIMAL(10, 4),
    pension_liab_pct DECIMAL(10, 4),
    rev_growth DECIMAL(10, 4),
    debt_to_revenue DECIMAL(10, 4),
    liquidity_ratio DECIMAL(10, 4),
    coverage_ratio DECIMAL(10, 4),
    provenance JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_metrics_issuer_id ON metrics(issuer_id);
CREATE INDEX idx_metrics_as_of ON metrics(as_of);

CREATE TABLE IF NOT EXISTS scores (
    score_id SERIAL PRIMARY KEY,
    issuer_id VARCHAR(255) NOT NULL,
    as_of DATE NOT NULL,
    irs INTEGER CHECK (irs >= 0 AND irs <= 100),
    trend VARCHAR(50),
    confidence DECIMAL(5, 4),
    drivers JSONB,
    model_hash VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_scores_issuer_id ON scores(issuer_id);
CREATE INDEX idx_scores_as_of ON scores(as_of);
CREATE INDEX idx_scores_irs ON scores(irs);

CREATE TABLE IF NOT EXISTS manifests (
    manifest_id SERIAL PRIMARY KEY,
    doc_id INTEGER REFERENCES documents(doc_id) ON DELETE CASCADE,
    part VARCHAR(255),
    sha256 VARCHAR(64),
    bytes BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_manifests_doc_id ON manifests(doc_id);

CREATE TABLE IF NOT EXISTS issuers (
    issuer_id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    state VARCHAR(2),
    county VARCHAR(255),
    sector VARCHAR(100),
    cusip VARCHAR(9),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_issuers_state ON issuers(state);
CREATE INDEX idx_issuers_sector ON issuers(sector);

CREATE TABLE IF NOT EXISTS events (
    event_id SERIAL PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    issuer_id VARCHAR(255),
    entity_type VARCHAR(100),
    entity_id VARCHAR(255),
    event_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_events_event_type ON events(event_type);
CREATE INDEX idx_events_issuer_id ON events(issuer_id);
CREATE INDEX idx_events_created_at ON events(created_at);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_documents_updated_at BEFORE UPDATE ON documents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_metrics_updated_at BEFORE UPDATE ON metrics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scores_updated_at BEFORE UPDATE ON scores
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_issuers_updated_at BEFORE UPDATE ON issuers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
