from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func
from typing import Optional, List
from app.core.database import get_db
from app.models.entities import (
    Product, ProductImage, ProductVariant, ProductAttribute,
    Category, ProductActivity, Activity, ActivityType
)
from app.schemas.product import (
    ProductOut, ProductListOut, CategoryOut, SearchResultOut,
    FilterFacetsOut, FacetOut, FacetValueOut, ActivityTag, VariantOut
)
import json

router = APIRouter(prefix="/api/products", tags=["商品"])


def get_product_tags(db: Session, product_id: int) -> List[ActivityTag]:
    """获取商品活动标签"""
    pa = db.query(ProductActivity).filter(ProductActivity.product_id == product_id).first()
    if not pa:
        return []
    act = db.query(Activity).filter(Activity.id == pa.activity_id, Activity.is_active == 1).first()
    if not act:
        return []
    at = db.query(ActivityType).filter(ActivityType.id == act.activity_type_id).first()
    if not at:
        return []
    label_map = {
        'discount': f'-{(json.loads(act.rules or "{}")).get("discount_percent", 0)}% OFF',
        'full_reduction': f'满{(json.loads(act.rules or "{}")).get("threshold", 0)}减{(json.loads(act.rules or "{}")).get("reduction", 0)}',
        'group_buy': 'Group Buy',
        'bargain': 'Bargain',
        'flash_sale': 'Flash Sale',
        'new_user': 'New User',
    }
    return [ActivityTag(type=at.type_key, label=label_map.get(at.type_key, at.type_name), icon=at.type_icon)]


def build_product_response(product: Product, tags: List[ActivityTag]) -> ProductListOut:
    return ProductListOut(
        id=product.id,
        category_id=product.category_id,
        source=product.source,
        name=product.name,
        brand=product.brand,
        material=product.material,
        is_active=product.is_active,
        main_image=product.images[0].url if product.images and product.images[0].is_main else (product.images[0].url if product.images else ""),
        min_retail_price=min(v.retail_price / 100 for v in product.variants) if product.variants else 0,
        min_b2b_price=min(v.b2b_price / 100 for v in product.variants) if product.variants else 0,
        tags=tags,
        images=[img for img in product.images] if product.images else [],
    )


@router.get("/search", response_model=SearchResultOut)
def search_products(
    q: Optional[str] = None,
    category_id: Optional[int] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    min_rating: Optional[float] = None,
    free_shipping: Optional[bool] = None,
    has_discount: Optional[bool] = None,
    has_bargain: Optional[bool] = None,
    has_full_reduction: Optional[bool] = None,
    sort: Optional[str] = "relevance",
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    # 查询
    query = db.query(Product).options(
        joinedload(Product.images),
        joinedload(Product.variants),
        joinedload(Product.activity_bind),
        joinedload(Product.activity_bind.and_(ProductActivity.id.isnot(None))),
    ).filter(Product.is_active == 1, Product.deleted_at.is_(None))

    if q:
        query = query.filter(Product.name.ilike(f"%{q}%"))
    if category_id:
        query = query.filter(Product.category_id == category_id)
    if min_price:
        # 转换分为元
        min_price_int = int(min_price * 100)
        query = query.join(Product.variants).filter(ProductVariant.retail_price >= min_price_int)
    if max_price:
        max_price_int = int(max_price * 100)
        query = query.join(Product.variants).filter(ProductVariant.retail_price <= max_price_int)

    # 排序
    if sort == "sales":
        query = query.order_by(Product.id.desc())
    elif sort == "price-low":
        query = query.join(Product.variants).order_by(ProductVariant.retail_price.asc())
    elif sort == "price-high":
        query = query.join(Product.variants).order_by(ProductVariant.retail_price.desc())
    elif sort == "newest":
        query = query.order_by(Product.created_at.desc())

    total = query.count()
    products = query.offset((page - 1) * page_size).limit(page_size).all()

    # 构建返回
    result_products = []
    for p in products:
        tags = get_product_tags(db, p.id)
        # 过滤活动
        if has_discount and not any(t.type == 'discount' for t in tags):
            continue
        if has_bargain and not any(t.type == 'bargain' for t in tags):
            continue
        if has_full_reduction and not any(t.type == 'full_reduction' for t in tags):
            continue
        result_products.append(build_product_response(p, tags))

    # 动态分面
    facet_query = db.query(
        ProductAttribute.name,
        ProductAttribute.value,
        func.count(ProductAttribute.id).label("count")
    ).join(Product, Product.id == ProductAttribute.product_id).filter(
        Product.is_active == 1, Product.deleted_at.is_(None)
    ).group_by(ProductAttribute.name, ProductAttribute.value)

    attr_counts = facet_query.all()
    facet_map = {}
    for name, value, count in attr_counts:
        if name not in facet_map:
            facet_map[name] = []
        facet_map[name].append(FacetValueOut(value=value, count=count))

    facets = [FacetOut(name=name, values=vals) for name, vals in facet_map.items()]

    return SearchResultOut(
        products=result_products,
        total=total,
        page=page,
        page_size=page_size,
        facets=FilterFacetsOut(facets=facets),
    )


@router.get("/{product_id}", response_model=ProductOut)
def get_product(product_id: int, db: Session = Depends(get_db)):
    product = db.query(Product).options(
        joinedload(Product.images),
        joinedload(Product.variants),
    ).filter(Product.id == product_id, Product.is_active == 1, Product.deleted_at.is_(None)).first()

    if not product:
        raise HTTPException(status_code=404, detail="商品不存在")

    tags = get_product_tags(db, product.id)
    variants = [VariantOut(
        id=v.id, sku=v.sku, specs=v.specs,
        retail_price=v.retail_price, b2b_price=v.b2b_price,
        b2b_min_qty=v.b2b_min_qty, weight=v.weight,
        stock_qty=v.stock_qty, is_active=v.is_active
    ) for v in product.variants]

    return ProductOut(
        id=product.id, category_id=product.category_id,
        source=product.source, name=product.name,
        brand=product.brand, material=product.material,
        unit=product.unit, is_active=product.is_active,
        created_at=product.created_at,
        images=[ProductImageOut(id=img.id, url=img.url, sort_order=img.sort_order, is_main=img.is_main) for img in product.images],
        variants=variants,
        tags=tags,
    )


@router.get("/categories/tree", response_model=List[CategoryOut])
def get_categories(db: Session = Depends(get_db)):
    cats = db.query(Category).filter(Category.is_active == 1).order_by(Category.sort_order).all()
    # 构建树
    cat_map = {c.id: c for c in cats}
    roots = []
    for c in cats:
        children = []
        for inner in cats:
            if inner.parent_id == c.id:
                children.append(CategoryOut(id=inner.id, parent_id=inner.parent_id, name=inner.name, slug=inner.slug, icon_url=inner.icon_url, sort_order=inner.sort_order, is_active=inner.is_active))
        roots.append(CategoryOut(id=c.id, parent_id=c.parent_id, name=c.name, slug=c.slug, icon_url=c.icon_url, sort_order=c.sort_order, is_active=c.is_active, children=children if children else []))
    return [r for r in roots if r.parent_id is None]
