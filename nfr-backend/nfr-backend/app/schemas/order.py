from pydantic import BaseModel
from typing import List, Optional
from decimal import Decimal


class CartItemCreate(BaseModel):
    product_id: int
    variant_id: Optional[int] = None
    quantity: int = 1


class CartItemOut(BaseModel):
    id: int
    product_id: int
    product_name: str
    product_image: Optional[str] = None
    variant_id: Optional[int] = None
    variant_name: Optional[str] = None
    price: Decimal
    quantity: int

    class Config:
        from_attributes = True


class CartOut(BaseModel):
    items: List[CartItemOut]
    total: Decimal


class OrderItemCreate(BaseModel):
    product_id: int
    variant_id: Optional[int] = None
    quantity: int = 1


class OrderCreate(BaseModel):
    items: List[OrderItemCreate]
    shipping_name: Optional[str] = None
    shipping_phone: Optional[str] = None
    shipping_address: Optional[str] = None
    note: Optional[str] = None


class OrderItemOut(BaseModel):
    id: int
    product_id: int
    product_name: str
    variant_name: Optional[str] = None
    price: Decimal
    quantity: int
    image_url: Optional[str] = None

    class Config:
        from_attributes = True


class OrderOut(BaseModel):
    id: int
    order_no: str
    total_amount: Decimal
    status: str
    shipping_name: Optional[str] = None
    shipping_phone: Optional[str] = None
    shipping_address: Optional[str] = None
    created_at: Optional[str] = None
    items: List[OrderItemOut] = []

    class Config:
        from_attributes = True
