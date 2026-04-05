from sqlalchemy import Column, BigInteger, String, Text, Integer, DECIMAL, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.core.database import Base


class Category(Base):
    __tablename__ = "categories"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)
    parent_id = Column(BigInteger, ForeignKey("categories.id"), nullable=True)
    level = Column(Integer, default=1)
    sort_order = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=None)
    parent = relationship("Category", remote_side=[id], backref="children")
    products = relationship("Product", back_populates="category")


class Product(Base):
    __tablename__ = "products"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    category_id = Column(BigInteger, ForeignKey("categories.id"), nullable=True)
    name = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    retail_price = Column(DECIMAL(10, 2), nullable=False)
    b2b_price = Column(DECIMAL(10, 2), nullable=True)
    rating = Column(DECIMAL(3, 2), default=0)
    sales_count = Column(Integer, default=0)
    view_count = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=None)
    updated_at = Column(DateTime, default=None)
    category = relationship("Category", back_populates="products")
    images = relationship("ProductImage", back_populates="product", cascade="all, delete-orphan")
    variants = relationship("ProductVariant", back_populates="product", cascade="all, delete-orphan")
    attributes = relationship("ProductAttribute", back_populates="product", cascade="all, delete-orphan")
    activity_bind = relationship("ProductActivity", back_populates="product", uselist=False, cascade="all, delete-orphan")


class ProductImage(Base):
    __tablename__ = "product_images"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    product_id = Column(BigInteger, ForeignKey("products.id"), nullable=False)
    image_url = Column(String(500), nullable=False)
    is_primary = Column(Boolean, default=False)
    sort_order = Column(Integer, default=0)
    product = relationship("Product", back_populates="images")


class ProductVariant(Base):
    __tablename__ = "product_variants"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    product_id = Column(BigInteger, ForeignKey("products.id"), nullable=False)
    sku = Column(String(100), unique=True, nullable=False)
    variant_name = Column(String(255), nullable=True)
    retail_price = Column(DECIMAL(10, 2), nullable=False)
    b2b_price = Column(DECIMAL(10, 2), nullable=True)
    stock = Column(Integer, default=0)
    product = relationship("Product", back_populates="variants")


class ProductAttribute(Base):
    __tablename__ = "product_attributes"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    product_id = Column(BigInteger, ForeignKey("products.id"), nullable=False)
    attr_name = Column(String(100), nullable=False)
    attr_value = Column(String(255), nullable=False)
    product = relationship("Product", back_populates="attributes")


class ActivityType(Base):
    __tablename__ = "activity_types"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(String(50), nullable=False)
    code = Column(String(50), unique=True, nullable=False)
    description = Column(Text, nullable=True)
    activities = relationship("Activity", back_populates="activity_type")


class Activity(Base):
    __tablename__ = "activities"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    activity_type_id = Column(BigInteger, ForeignKey("activity_types.id"), nullable=False)
    name = Column(String(200), nullable=False)
    start_time = Column(DateTime, nullable=False)
    end_time = Column(DateTime, nullable=False)
    is_active = Column(Boolean, default=True)
    activity_type = relationship("ActivityType", back_populates="activities")
    product_binds = relationship("ProductActivity", back_populates="activity")


class ProductActivity(Base):
    __tablename__ = "product_activity"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    product_id = Column(BigInteger, ForeignKey("products.id"), unique=True, nullable=False)
    activity_id = Column(BigInteger, ForeignKey("activities.id"), nullable=False)
    product = relationship("Product", back_populates="activity_bind")
    activity = relationship("Activity", back_populates="product_binds")


class CartItem(Base):
    __tablename__ = "cart_items"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id = Column(BigInteger, ForeignKey("users.id"), nullable=False)
    product_id = Column(BigInteger, ForeignKey("products.id"), nullable=False)
    variant_id = Column(BigInteger, ForeignKey("product_variants.id"), nullable=True)
    quantity = Column(Integer, default=1)
    created_at = Column(DateTime, default=None)
    product = relationship("Product")
    variant = relationship("ProductVariant")


class Order(Base):
    __tablename__ = "orders"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id = Column(BigInteger, ForeignKey("users.id"), nullable=False)
    order_no = Column(String(64), unique=True, nullable=False)
    total_amount = Column(DECIMAL(10, 2), nullable=False)
    status = Column(String(20), default="pending")
    shipping_name = Column(String(100), nullable=True)
    shipping_phone = Column(String(50), nullable=True)
    shipping_address = Column(Text, nullable=True)
    note = Column(Text, nullable=True)
    created_at = Column(DateTime, default=None)
    updated_at = Column(DateTime, default=None)
    items = relationship("OrderItem", back_populates="order", cascade="all, delete-orphan")


class OrderItem(Base):
    __tablename__ = "order_items"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    order_id = Column(BigInteger, ForeignKey("orders.id"), nullable=False)
    product_id = Column(BigInteger, ForeignKey("products.id"), nullable=False)
    variant_id = Column(BigInteger, ForeignKey("product_variants.id"), nullable=True)
    product_name = Column(String(255), nullable=False)
    variant_name = Column(String(255), nullable=True)
    price = Column(DECIMAL(10, 2), nullable=False)
    quantity = Column(Integer, nullable=False)
    image_url = Column(String(500), nullable=True)
    order = relationship("Order", back_populates="items")
