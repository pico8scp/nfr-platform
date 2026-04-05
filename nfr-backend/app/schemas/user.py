from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime


class UserBase(BaseModel):
    email: Optional[str] = None
    phone: Optional[str] = None
    username: str


class UserCreate(UserBase):
    email: Optional[str] = None
    phone: Optional[str] = None
    password: str


class UserOut(BaseModel):
    id: int
    email: Optional[str]
    phone: Optional[str]
    username: str
    avatar_url: str
    role: str
    is_verified: int
    created_at: Optional[datetime]

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    user_id: Optional[int] = None
