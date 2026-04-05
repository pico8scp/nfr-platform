from sqlalchemy import Column, BigInteger, String, Integer, DateTime, Enum, ForeignKey, Index
from sqlalchemy.sql import func
from app.core.database import Base


class Category(Base):
    __tablename__ = "categories"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    parent_id = Column(BigInteger, ForeignKey("categories.id", ondelete="SET NULL"), nullable=True)
    name = Column(String(100), nullable=False)
    slug = Column(String(100), unique=True, nullable=False, index=True)
    icon_url = Column(String(500), default="")
    sort_order = Column(Integer, default=0, index=True)
    is_active = Column(BigInteger, default=1)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    __table_args__ = (
        Index('idx_parent_id', 'parent_id'),
    )


class Product(Base):
    __tablename__ = "products"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    category_id = Column(BigInteger, ForeignKey("categories.id", ondelete="SET NULL"), nullable=True, index=True)
    source = Column(Enum('1688', 'shein', 'manual', name='product_source'), default='manual', nullable=False)
    source_id = Column(String(100), default="")
    source_url = Column(String(1000), default="")
    name = Column(String(500), nullable=False, index=True)
    description = Column(String(20000), nullable=True)
    brand = Column(String(100), default="")
    material = Column(String(100), default="")
    unit = Column(String(20), default="件")
    is_active = Column(BigInteger, default=1, index=True)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
    deleted_at = Column(DateTime, nullable=True)

    __table_args__ = (
        Index('idx_deleted_at', 'deleted_at'),
    )


class ProductImage(Base):
    __tablename__ = "product_images"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    product_id = Column(BigInteger, ForeignKey("products.id", ondelete="CASCADE"), nullable=False, index=True)
    url = Column(String(1000), nullable=False)
    sort_order = Column(Integer, default=0, index=True)
    is_main = Column(BigInteger, default=0)


class ProductVariant(Base):
    __tablename__ = "product_variants"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    product_id = Column(BigInteger, ForeignKey("products.id", ondelete="CASCADE"), nullable=False, index=True)
    sku = Column(String(100), unique=True, nullable=False, index=True)
    specs = Column(String(2000), nullable=True)
    retail_price = Column(BigInteger, default=0)
    b2b_price = Column(BigInteger, default=0)
    b2b_min_qty = Column(Integer, default=1)
    cost_price = Column(BigInteger, default=0)
    weight = Column(Integer, default=0)
    source_variant_id = Column(String(100), default="")
    stock_qty = Column(Integer, default=0)
    is_active = Column(BigInteger, default=1)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())


class ProductAttribute(Base):
    __tablename__ = "product_attributes"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    product_id = Column(BigInteger, ForeignKey("products.id", ondelete="CASCADE"), nullable=False, index=True)
    name = Column(String(50), nullable=False)
    value = Column(String(200), nullable=False)

    __table_args__ = (
        Index('idx_name_value', 'name', 'value'),
    )


class ActivityType(Base):
    __tablename__ = "activity_types"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    type_key = Column(String(30), unique=True, nullable=False)
    type_name = Column(String(50), nullable=False)
    type_icon = Column(String(20), default="")
    description = Column(String(200), default="")
    rules_schema = Column(String(4000), nullable=True)
    created_at = Column(DateTime, server_default=func.now())


class Activity(Base):
    __tablename__ = "activities"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    activity_type_id = Column(BigInteger, ForeignKey("activity_types.id"), nullable=False, index=True)
    name = Column(String(100), nullable=False)
    rules = Column(String(4000), nullable=True)
    start_time = Column(DateTime, nullable=False)
    end_time = Column(DateTime, nullable=False)
    is_active = Column(BigInteger, default=1, index=True)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    __table_args__ = (
        Index('idx_time_range', 'start_time', 'end_time'),
    )


class ProductActivity(Base):
    __tablename__ = "product_activity"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    product_id = Column(BigInteger, ForeignKey("products.id", ondelete="CASCADE"), unique=True, nullable=False)
    activity_id = Column(BigInteger, ForeignKey("activities.id", ondelete="CASCADE"), nullable=False, index=True)
    priority = Column(Integer, default=0, index=True)
    created_at = Column(DateTime, server_default=func.now())

    __table_args__ = (
        Index('uk_product_id', 'product_id', unique=True),
    )


class CartItem(Base):
    __tablename__ = "cart_items"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    variant_id = Column(BigInteger, ForeignKey("product_variants.id", ondelete="CASCADE"), nullable=False, index=True)
    quantity = Column(Integer, default=1, nullable=False)
    order_type = Column(Enum('b2c', 'b2b', name='order_type_enum'), default='b2c', nullable=False)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    __table_args__ = (
        Index('uk_user_variant_type', 'user_id', 'variant_id', 'order_type', unique=True),
    )


class Order(Base):
    __tablename__ = "orders"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    order_no = Column(String(32), unique=True, nullable=False, index=True)
    user_id = Column(BigInteger, ForeignKey("users.id"), nullable=False, index=True)
    order_type = Column(Enum('b2c', 'b2b', name='order_type_enum2'), default='b2c', nullable=False)
    distributor_id = Column(BigInteger, ForeignKey("users.id", ondelete="SET NULL"), nullable=True, index=True)
    status = Column(Enum('pending', 'paid', 'processing', 'shipped', 'delivered', 'completed', 'cancelled', 'refunded', name='order_status'), default='pending', nullable=False, index=True)
    receiver_name = Column(String(50), default="")
    receiver_phone = Column(String(20), default="")
    receiver_address = Column(String(500), default="")
    subtotal = Column(BigInteger, default=0)
    activity_discount = Column(BigInteger, default=0)
    freight = Column(BigInteger, default=0)
    total_amount = Column(BigInteger, default=0)
    remark = Column(String(500), default="")
    paid_at = Column(DateTime, nullable=True)
    shipped_at = Column(DateTime, nullable=True)
    delivered_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), index=True)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
    deleted_at = Column(DateTime, nullable=True)


class OrderItem(Base):
    __tablename__ = "order_items"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    order_id = Column(BigInteger, ForeignKey("orders.id", ondelete="CASCADE"), nullable=False, index=True)
    variant_id = Column(BigInteger, ForeignKey("product_variants.id"), nullable=False, index=True)
    product_name = Column(String(500), nullable=False)
    sku = Column(String(100), default="")
    specs = Column(String(2000), nullable=True)
    quantity = Column(Integer, default=1, nullable=False)
    unit_price = Column(BigInteger, default=0)
    subtotal = Column(BigInteger, default=0)
    activity_type = Column(String(30), nullable=True)
    activity_discount = Column(BigInteger, default=0)
    source_variant_id = Column(String(100), default="")
    source_order_id = Column(String(100), default="")
    created_at = Column(DateTime, server_default=func.now())
