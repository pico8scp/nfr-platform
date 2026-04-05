from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.security import verify_password, hash_password, create_access_token
from app.models.user import User
from app.schemas.user import UserCreate, UserOut, Token

router = APIRouter(prefix="/api/auth", tags=["认证"])


@router.post("/register", response_model=UserOut)
def register(data: UserCreate, db: Session = Depends(get_db)):
    # 检查邮箱/手机号是否已存在
    if data.email:
        existing = db.query(User).filter(User.email == data.email, User.deleted_at.is_(None)).first()
        if existing:
            raise HTTPException(status_code=400, detail="邮箱已被注册")
    if data.phone:
        existing = db.query(User).filter(User.phone == data.phone, User.deleted_at.is_(None)).first()
        if existing:
            raise HTTPException(status_code=400, detail="手机号已被注册")

    user = User(
        email=data.email or "",
        phone=data.phone or "",
        password_hash=hash_password(data.password),
        username=data.username,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@router.post("/login", response_model=Token)
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(User).filter(
        (User.email == form_data.username) | (User.phone == form_data.username),
        User.deleted_at.is_(None)
    ).first()

    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(status_code=401, detail="用户名或密码错误", headers={"WWW-Authenticate": "Bearer"})

    token = create_access_token(data={"sub": str(user.id)})
    return {"access_token": token, "token_type": "bearer"}


@router.get("/me", response_model=UserOut)
def get_me(db: Session = Depends(get_db), current_user: User = Depends(__import__("app.core.security", fromlist=["get_current_user"]).get_current_user)):
    if not current_user:
        raise HTTPException(status_code=401, detail="未登录")
    return current_user
