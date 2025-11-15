import redis
from typing import Optional, Any
import json
import structlog

logger = structlog.get_logger()


class RedisClient:
    def __init__(self, host: str, port: int, password: str, db: int = 0):
        self.client = redis.Redis(
            host=host, port=port, password=password, db=db, decode_responses=True
        )
        logger.info("Redis client initialized", host=host, port=port)

    def ping(self) -> bool:
        """Check Redis connectivity"""
        try:
            return self.client.ping()
        except Exception as e:
            logger.error("Redis ping failed", error=str(e))
            return False

    def get(self, key: str) -> Optional[str]:
        """Get value by key"""
        return self.client.get(key)

    def set(self, key: str, value: Any, ex: Optional[int] = None):
        """Set key-value pair with optional expiration"""
        if isinstance(value, (dict, list)):
            value = json.dumps(value)
        self.client.set(key, value, ex=ex)

    def delete(self, key: str):
        """Delete key"""
        self.client.delete(key)

    def exists(self, key: str) -> bool:
        """Check if key exists"""
        return self.client.exists(key) > 0

    def close(self):
        """Close Redis connection"""
        self.client.close()
        logger.info("Redis connection closed")
