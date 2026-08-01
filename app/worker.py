"""
Ocean Bridge Trade - Arq Job Queue Worker

Lightweight job queue for background tasks.
"""
from arq import Worker
from app.config import get_settings

settings = get_settings()


async def startup(ctx):
    """Worker startup hook."""
    # Initialize database connection, etc.
    pass


async def shutdown(ctx):
    """Worker shutdown hook."""
    # Cleanup resources
    pass


class WorkerSettings:
    """Arq worker configuration."""
    
    functions = []  # Register jobs here as we build them
    on_startup = startup
    on_shutdown = shutdown
    redis_settings = {
        'host': settings.REDIS_HOST,
        'port': settings.REDIS_PORT,
        'db': settings.REDIS_DB,
        'password': settings.REDIS_PASSWORD,
    }
