from datetime import datetime
from decimal import Decimal
from typing import List, Optional
from sqlalchemy.orm import joinedload
from sqlalchemy import and_, or_, func
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.models.user import User
from app.models.entities import Category, Product, ProductImage, ProductVariant, ProductAttribute, Activity, ProductActivity
from app.schemas.product import (
    ProductOut, ProductListOut, CategoryOut, SearchResultOut, FilterFacetsOut, FacetOut, FacetValue, ActivityTag,
    ProductImageOut, ProductVariantOut, ProductAttributeOut
)
from app.core.security import get_current_user

router = APIRouter(prefix="/api/products", tags=["products"])


def get_product_tags(product: Product) -> List[ActivityTag]:
    """Generate activity tags for a product."""
    tags = []
    if product.sales_count >= 10000:
        tags.append(ActivityTag(type="hot", label="Hot Selling"))
    if product.activity_bind and product.activity_bind.activity:
        act = product.activity_bind.activity
        if act.activity_type and act.activity_type.code == "bargain":
            tags.append(ActivityTag(type="bargain", label="Bargain"))
        elif act.activity_type and act.activity_type.code == "full_reduction":
            tags.append(ActivityTag(type="full", label="满减"))
        elif act.activity_type and act.activity_type.code == "flash_sale":
            tags.append(ActivityTag(type="promo", label="限时特惠"))
        elif act.activity_type and act.activity_type.code == "group_buy":
            tags.append(ActivityTag(type="promo", label="拼团"))
    if not tags and product.created_at and (datetime.now() - product.created_at).days < 7:
        tags.append(ActivityTag(type="new", label="New Arrival"))
    return tags


def calculate_discount(product: Product) -> int:
    return 0


def product_to_list_out(product: Product) -> ProductListOut:
    img = None
    for im in product.images:
        if im.is_primary:
            img = im.image_url
            break
    if not img and product.images:
        img = product.images[0].image_url
    if not img:
        img = "https://via.placeholder.com/400x480"

    tags = get_product_tags(product)
    return ProductListOut(
        id=product.id,
        name=product.name,
        img=img,
        price=str(product.retail_price),
        original_price=None,
        discount=calculate_discount(product),
        rating=product.rating,
        sold=product.sales_count,
        tags=tags,
        has_bargain=any(t.type == "bargain" for t in tags),
        bargain_min_discount=None,
        has_full_reduction=any(t.type == "full" for t in tags),
        full_reduction_threshold=None,
        full_reduction_amount=None,
        has_group_buy=any(t.type == "promo" for t in tags),
        has_discount=calculate_discount(product) > 0,
    )


@router.get("/categories/tree")
def get_category_tree(db: Session = Depends(get_db)):
    roots = db.query(Category).filter(
        Category.parent_id == None,
        Category.is_active == True
    ).order_by(Category.sort_order).all()

    def build_tree(cat: Category) -> CategoryOut:
        children = [build_tree(c) for c in cat.children if c.is_active]
        return CategoryOut(
            id=cat.id,
            name=cat.name,
            parent_id=cat.parent_id,
            level=cat.level,
            children=children,
        )

    return [build_tree(r) for r in roots]


@router.get("/search", response_model=SearchResultOut)
def search_products(
    q: Optional[str] = None,
    category_id: Optional[int] = None,
    price_min: Optional[float] = None,
    price_max: Optional[float] = None,
    min_rating: Optional[float] = None,
    sort: Optional[str] = "relevance",
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    query = db.query(Product).filter(Product.is_active == True)

    if q:
        query = query.filter(or_(
            Product.name.ilike(f"%{q}%"),
            Product.description.ilike(f"%{q}%"),
        ))
    if category_id:
        query = query.filter(Product.category_id == category_id)
    if price_min is not None:
        query = query.filter(Product.retail_price >= price_min)
    if price_max is not None:
        query = query.filter(Product.retail_price <= price_max)
    if min_rating is not None:
        query = query.filter(Product.rating >= min_rating)

    total = query.count()

    if sort == "sales":
        query = query.order_by(Product.sales_count.desc())
    elif sort == "newest":
        query = query.order_by(Product.created_at.desc())
    elif sort == "price-low":
        query = query.order_by(Product.retail_price.asc())
    elif sort == "price-high":
        query = query.order_by(Product.retail_price.desc())
    elif sort == "rating":
        query = query.order_by(Product.rating.desc())
    else:
        query = query.order_by(Product.id.desc())

    offset = (page - 1) * page_size
    products = query.options(
        joinedload(Product.images),
        joinedload(Product.variants),
        joinedload(Product.activity_bind).joinedload(ProductActivity.activity).joinedload(Activity.activity_type),
    ).offset(offset).limit(page_size).all()

    attr_stats = db.query(
        ProductAttribute.attr_name,
        ProductAttribute.attr_value,
        func.count(ProductAttribute.product_id).label("count")
    ).join(Product).filter(Product.is_active == True).group_by(
        ProductAttribute.attr_name, ProductAttribute.attr_value
    ).all()

    facet_map = {}
    for attr_name, attr_value, count in attr_stats:
        if attr_name not in facet_map:
            facet_map[attr_name] = []
        facet_map[attr_name].append(FacetValue(value=attr_value, count=count))

    facets = [FacetOut(name=name, values=values[:10]) for name, values in facet_map.items()]

    return SearchResultOut(
        products=[product_to_list_out(p) for p in products],
        total=total,
        page=page,
        page_size=page_size,
        facets=facets,
    )


@router.get("/{product_id}", response_model=ProductOut)
def get_product(product_id: int, db: Session = Depends(get_db)):
    product = db.query(Product).options(
        joinedload(Product.images),
        joinedload(Product.variants),
        joinedload(Product.attributes),
        joinedload(Product.activity_bind).joinedload(ProductActivity.activity).joinedload(Activity.activity_type),
    ).filter(Product.id == product_id, Product.is_active == True).first()

    if not product:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="Product not found")

    tags = get_product_tags(product)
    return ProductOut(
        id=product.id,
        name=product.name,
        category_id=product.category_id,
        description=product.description,
        retail_price=product.retail_price,
        b2b_price=product.b2b_price,
        rating=product.rating,
        sales_count=product.sales_count,
        images=[ProductImageOut(id=i.id, image_url=i.image_url, is_primary=i.is_primary) for i in product.images],
        variants=[ProductVariantOut(
            id=v.id,
            sku=v.sku,
            variant_name=v.variant_name,
            retail_price=v.retail_price,
            b2b_price=v.b2b_price,
            stock=v.stock,
        ) for v in product.variants],
        attributes=[ProductAttributeOut(attr_name=a.attr_name, attr_value=a.attr_value) for a in product.attributes],
        tags=tags,
        discount=0,
        has_bargain=any(t.type == "bargain" for t in tags),
        bargain_min_discount=None,
        has_full_reduction=any(t.type == "full" for t in tags),
        full_reduction_threshold=None,
        full_reduction_amount=None,
    )
