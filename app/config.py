"""
Ocean Bridge Trade - Application Configuration

Configuration settings loaded from environment variables.
Never commit real secrets to version control.
"""
from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    # Application
    APP_NAME: str = "Ocean Bridge Trade Engine"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = False
    
    # Database
    DATABASE_URL: str
    
    # Redis (for Arq job queue)
    REDIS_HOST: str = "localhost"
    REDIS_PORT: int = 6379
    REDIS_DB: int = 0
    REDIS_PASSWORD: str | None = None
    
    # Model routing
    MODEL_PROVIDER: str = "mock"
    MODEL_TIMEOUT_SECONDS: int = 60
    MODEL_MAX_RETRIES: int = 2
    
    # API Keys (all optional, injected via environment)
    NVIDIA_API_KEY: str | None = None
    HUGGINGFACE_API_TOKEN: str | None = None
    APIFY_TOKEN: str | None = None
    APOLLO_API_KEY: str | None = None
    PROSPEO_API_KEY: str | None = None
    MILLIONVERIFIER_API_KEY: str | None = None
    
    # Legacy n8n fields (accepted but not used in Python engine)
    N8N_HOST: str | None = None
    N8N_PROTOCOL: str | None = None
    WEBHOOK_URL: str | None = None
    N8N_ENCRYPTION_KEY: str | None = None
    GENERIC_TIMEZONE: str | None = None
    NVIDIA_MODEL: str | None = None
    HUGGINGFACE_MODEL: str | None = None
    GOOGLE_SHEETS_SPREADSHEET_ID: str | None = None
    
    class Config:
        env_file = ".env"
        case_sensitive = True
        extra = 'ignore'  # Ignore unknown fields from .env


@lru_cache()
def get_settings() -> Settings:
    """Get cached settings instance."""
    return Settings()
