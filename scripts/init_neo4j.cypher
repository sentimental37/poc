// Initialize MuniLens Neo4j Graph Schema

// Create constraints for unique identifiers
CREATE CONSTRAINT issuer_id IF NOT EXISTS FOR (i:Issuer) REQUIRE i.id IS UNIQUE;
CREATE CONSTRAINT obligor_id IF NOT EXISTS FOR (o:Obligor) REQUIRE o.id IS UNIQUE;
CREATE CONSTRAINT project_id IF NOT EXISTS FOR (p:Project) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT security_cusip IF NOT EXISTS FOR (s:Security) REQUIRE s.cusip IS UNIQUE;

// Create indexes for common queries
CREATE INDEX issuer_name IF NOT EXISTS FOR (i:Issuer) ON (i.name);
CREATE INDEX issuer_state IF NOT EXISTS FOR (i:Issuer) ON (i.state);
CREATE INDEX issuer_sector IF NOT EXISTS FOR (i:Issuer) ON (i.sector);
CREATE INDEX obligor_name IF NOT EXISTS FOR (o:Obligor) ON (o.name);
CREATE INDEX project_name IF NOT EXISTS FOR (p:Project) ON (p.name);
CREATE INDEX security_maturity IF NOT EXISTS FOR (s:Security) ON (s.maturity);

// Example node creation (for testing)
// CREATE (i:Issuer {id: 'test-issuer-001', name: 'Test Municipality', state: 'CA', sector: 'municipal'});
// CREATE (o:Obligor {id: 'test-obligor-001', name: 'Test Obligor', sector: 'utility'});
// CREATE (p:Project {id: 'test-project-001', name: 'Infrastructure Project', kind: 'infrastructure'});
// CREATE (s:Security {cusip: '123456789', coupon: 4.5, maturity: date('2030-12-31'), callable: true});

// Example relationship creation (for testing)
// MATCH (i:Issuer {id: 'test-issuer-001'}), (s:Security {cusip: '123456789'})
// CREATE (i)-[:ISSUES {issue_date: date('2020-01-01'), amount: 10000000}]->(s);
