from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic_settings import BaseSettings
import structlog

logger = structlog.get_logger()


class Settings(BaseSettings):
    app_name: str = "MuniLens API"
    environment: str = "development"
    debug: bool = True
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    
    postgres_host: str = "localhost"
    postgres_port: int = 5432
    postgres_db: str = "munilens"
    postgres_user: str = "munilens"
    postgres_password: str = "munilens_dev_password"
    
    neo4j_uri: str = "bolt://localhost:7687"
    neo4j_user: str = "neo4j"
    neo4j_password: str = "neo4j_dev_password"
    
    redis_host: str = "localhost"
    redis_port: int = 6379
    redis_password: str = "redis_dev_password"
    
    class Config:
        env_file = ".env"


settings = Settings()

app = FastAPI(
    title=settings.app_name,
    description="AI-Powered Disclosure Intelligence System for Dynamic Credit Risk Assessment",
    version="0.1.0",
    debug=settings.debug,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "Welcome to MuniLens API",
        "version": "0.1.0",
        "environment": settings.environment,
    }


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": "munilens-api",
        "environment": settings.environment,
    }


@app.get("/api/v1/status")
async def api_status():
    """API status endpoint with service connectivity checks"""
    status = {
        "api": "operational",
        "database": "not_configured",
        "graph_db": "not_configured",
        "cache": "not_configured",
    }
    
    
    return status


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host=settings.api_host,
        port=settings.api_port,
        reload=settings.debug,
    )
