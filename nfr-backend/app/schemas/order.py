from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class CartItemCreate(BaseModel):
    variant_id: int
    quantity: int = 1
    order_type: str = "b2c"


class CartItemOut(BaseModel):
    id: int
    user_id: int
    variant_id: int
    quantity: int
    order_type: str
    product_name: str = ""
    product_image: str = ""
    sku: str = ""
    specs: str = ""
    retail_price: int = 0
    b2b_price: int = 0
    subtotal: int = 0

    @property
    def retail_price_yuan(self) -> float:
        return self.retail_price / 100

    @property
    def b2b_price_yuan(self) -> float:
        return self.b2b_price / 100

    class Config:
        from_attributes = True


class CartOut(BaseModel):
    items: List[CartItemOut]
    total_count: int
    total_amount: int

    @property
    def total_amount_yuan(self) -> float:
        return self.total_amount / 100

    class Config:
        from_attributes = True


class OrderCreate(BaseModel):
    receiver_name: str
    receiver_phone: str
    receiver_address: str
    remark: str = ""


class OrderItemOut(BaseModel):
    id: int
    variant_id: int
    product_name: str
    sku: str
    specs: Optional[str]
    quantity: int
    unit_price: int
    subtotal: int
    activity_type: Optional[str]
    activity_discount: int

    @property
    def unit_price_yuan(self) -> float:
        return self.unit_price / 100

    class Config:
        from_attributes = True


class OrderOut(BaseModel):
    id: int
    order_no: str
    user_id: int
    order_type: str
    status: str
    receiver_name: str
    receiver_phone: str
    receiver_address: str
    subtotal: int
    activity_discount: int
    freight: int
    total_amount: int
    remark: str
    created_at: Optional[datetime]
    items: List[OrderItemOut] = []

    @property
    def total_amount_yuan(self) -> float:
        return self.total_amount / 100

    class Config:
        from_attributes = True
