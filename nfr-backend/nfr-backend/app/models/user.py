from sqlalchemy import Column, BigInteger, String, Boolean, DateTime, Enum
from app.core.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    email = Column(String(255), unique=True, nullable=False, index=True)
    phone = Column(String(50), unique=True, nullable=True)
    password_hash = Column(String(255), nullable=False)
    username = Column(String(100), nullable=False)
    user_type = Column(String(20), default="customer")
    is_deleted = Column(Boolean, default=False)
    created_at = Column(DateTime, default=None)
    updated_at = Column(DateTime, default=None)
