from sqlalchemy import Column, BigInteger, String, DateTime, Enum, Index
from sqlalchemy.sql import func
from app.core.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(BigInteger, primary_key=True, index=True, autoincrement=True)
    email = Column(String(191), unique=True, index=True, nullable=False)
    phone = Column(String(20), unique=True, index=True, nullable=True)
    password_hash = Column(String(255), nullable=False)
    username = Column(String(50), nullable=False)
    avatar_url = Column(String(500), default="")
    role = Column(Enum('customer', 'distributor', 'admin', name='user_role'), default='customer', nullable=False)
    parent_distributor_id = Column(BigInteger, index=True, nullable=True)
    is_verified = Column(BigInteger, default=0)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
    deleted_at = Column(DateTime, nullable=True)

    __table_args__ = (
        Index('idx_deleted_at', 'deleted_at'),
    )
