from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    database_url: str = "mysql+pymysql://nfr:nfr_password_2026@localhost:3306/nfr_platform"
    secret_key: str = "nfr-platform-super-secret-key-2026-change-in-production"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 60 * 24 * 7
    cors_origins: str = "http://192.168.1.67:3000,http://localhost:3000"
    redis_url: str = "redis://localhost:6379/0"
    app_name: str = "NFR Platform API"
    debug: bool = False

    def get_cors_origins(self) -> List[str]:
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()]

    class Config:
        env_file = ".env"
        extra = "ignore"


_settings = None


def get_settings() -> Settings:
    global _settings
    if _settings is None:
        _settings = Settings()
    return _settings
