from pydantic import BaseModel, EmailStr
from typing import Optional


class UserCreate(BaseModel):
    email: EmailStr
    password: str
    username: str
    phone: Optional[str] = None


class UserOut(BaseModel):
    id: int
    email: str
    username: str
    phone: Optional[str] = None
    user_type: str

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    user_id: Optional[int] = None
