"""
Smoke test for foundation setup.
This ensures pytest has at least one test to run during Phase 0.
"""
from services.backend.database.postgres import get_connection_string


def test_postgres_connection_string():
    """Test that PostgreSQL connection string is generated correctly."""
    conn_str = get_connection_string(
        host="localhost",
        port=5432,
        db="test_db",
        user="test_user",
        password="test_pass"
    )
    assert conn_str == "postgresql://test_user:test_pass@localhost:5432/test_db"
    assert conn_str.startswith("postgresql://")


def test_placeholder():
    """Placeholder test to ensure pytest runs successfully."""
    assert True
