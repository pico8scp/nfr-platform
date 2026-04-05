from datetime import datetime
from decimal import Decimal
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.security import get_current_user
from app.models.user import User
from app.models.entities import CartItem, Product, ProductVariant
from app.schemas.order import CartItemCreate, CartItemOut, CartOut

router = APIRouter(prefix="/api/cart", tags=["cart"])


@router.get("", response_model=CartOut)
def get_cart(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get current user's cart."""
    items = db.query(CartItem).filter(CartItem.user_id == current_user.id).all()
    total = Decimal("0")
    out_items = []
    for item in items:
        product = db.query(Product).filter(Product.id == item.product_id).first()
        if not product:
            continue
        variant = db.query(ProductVariant).filter(ProductVariant.id == item.variant_id).first() if item.variant_id else None
        price = (variant.retail_price if variant else product.retail_price)
        total += price * item.quantity
        img_url = None
        if product.images:
            for im in product.images:
                if im.is_primary:
                    img_url = im.image_url
                    break
            if not img_url:
                img_url = product.images[0].image_url
        out_items.append(CartItemOut(
            id=item.id,
            product_id=item.product_id,
            product_name=product.name,
            product_image=img_url,
            variant_id=item.variant_id,
            variant_name=variant.variant_name if variant else None,
            price=price,
            quantity=item.quantity,
        ))
    return CartOut(items=out_items, total=total)


@router.post("/items", response_model=CartItemOut)
def add_to_cart(
    item: CartItemCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Add item to cart."""
    product = db.query(Product).filter(Product.id == item.product_id, Product.is_active == True).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    # Check variant if provided
    if item.variant_id:
        variant = db.query(ProductVariant).filter(
            ProductVariant.id == item.variant_id,
            ProductVariant.product_id == item.product_id,
        ).first()
        if not variant:
            raise HTTPException(status_code=404, detail="Variant not found")

    # Check existing cart item
    existing = db.query(CartItem).filter(
        CartItem.user_id == current_user.id,
        CartItem.product_id == item.product_id,
        CartItem.variant_id == item.variant_id,
    ).first()

    if existing:
        existing.quantity += item.quantity
        db.commit()
        db.refresh(existing)
        cart_item = existing
    else:
        cart_item = CartItem(
            user_id=current_user.id,
            product_id=item.product_id,
            variant_id=item.variant_id,
            quantity=item.quantity,
        )
        db.add(cart_item)
        db.commit()
        db.refresh(cart_item)

    # Build response
    variant = db.query(ProductVariant).filter(ProductVariant.id == cart_item.variant_id).first() if cart_item.variant_id else None
    price = (variant.retail_price if variant else product.retail_price)
    img_url = None
    if product.images:
        for im in product.images:
            if im.is_primary:
                img_url = im.image_url
                break
        if not img_url:
            img_url = product.images[0].image_url

    return CartItemOut(
        id=cart_item.id,
        product_id=cart_item.product_id,
        product_name=product.name,
        product_image=img_url,
        variant_id=cart_item.variant_id,
        variant_name=variant.variant_name if variant else None,
        price=price,
        quantity=cart_item.quantity,
    )


@router.delete("/items/{item_id}")
def remove_from_cart(
    item_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Remove item from cart."""
    item = db.query(CartItem).filter(
        CartItem.id == item_id,
        CartItem.user_id == current_user.id,
    ).first()
    if not item:
        raise HTTPException(status_code=404, detail="Cart item not found")
    db.delete(item)
    db.commit()
    return {"ok": True}
