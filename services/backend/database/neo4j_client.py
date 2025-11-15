from neo4j import GraphDatabase
from typing import List, Dict, Any
import structlog

logger = structlog.get_logger()


class Neo4jClient:
    def __init__(self, uri: str, user: str, password: str):
        self.driver = GraphDatabase.driver(uri, auth=(user, password))
        logger.info("Neo4j client initialized", uri=uri)

    def close(self):
        """Close the driver connection"""
        self.driver.close()
        logger.info("Neo4j connection closed")

    def verify_connectivity(self) -> bool:
        """Verify connection to Neo4j"""
        try:
            with self.driver.session() as session:
                result = session.run("RETURN 1 as num")
                return result.single()["num"] == 1
        except Exception as e:
            logger.error("Neo4j connectivity check failed", error=str(e))
            return False

    def execute_query(
        self, query: str, parameters: Dict[str, Any] = None
    ) -> List[Dict]:
        """Execute a Cypher query"""
        with self.driver.session() as session:
            result = session.run(query, parameters or {})
            return [record.data() for record in result]

    def execute_write(self, query: str, parameters: Dict[str, Any] = None):
        """Execute a write transaction"""
        with self.driver.session() as session:
            session.write_transaction(lambda tx: tx.run(query, parameters or {}))
