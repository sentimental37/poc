from typing import Generator

import structlog
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

logger = structlog.get_logger()

Base = declarative_base()


class PostgresDatabase:
    def __init__(self, connection_string: str):
        self.engine = create_engine(connection_string, pool_pre_ping=True)
        self.SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=self.engine)

    def get_db(self) -> Generator:
        """Get database session"""
        db = self.SessionLocal()
        try:
            yield db
        finally:
            db.close()

    def create_tables(self):
        """Create all tables"""
        Base.metadata.create_all(bind=self.engine)
        logger.info("Database tables created")

    def drop_tables(self):
        """Drop all tables"""
        Base.metadata.drop_all(bind=self.engine)
        logger.info("Database tables dropped")


def get_connection_string(host: str, port: int, db: str, user: str, password: str) -> str:
    """Generate PostgreSQL connection string"""
    return f"postgresql://{user}:{password}@{host}:{port}/{db}"
