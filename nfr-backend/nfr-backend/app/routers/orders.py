import uuid
from datetime import datetime
from decimal import Decimal
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from app.core.database import get_db
from app.core.security import get_current_user
from app.models.user import User
from app.models.entities import Order, OrderItem, CartItem, Product, ProductVariant
from app.schemas.order import OrderCreate, OrderOut, OrderItemOut

router = APIRouter(prefix="/api/orders", tags=["orders"])


@router.get("", response_model=list[OrderOut])
def list_orders(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """List current user's orders."""
    orders = db.query(Order).options(joinedload(Order.items)).filter(
        Order.user_id == current_user.id
    ).order_by(Order.created_at.desc()).all()

    return [OrderOut(
        id=o.id,
        order_no=o.order_no,
        total_amount=o.total_amount,
        status=o.status.value,
        shipping_name=o.shipping_name,
        shipping_phone=o.shipping_phone,
        shipping_address=o.shipping_address,
        created_at=o.created_at.isoformat() if o.created_at else None,
        items=[OrderItemOut(
            id=i.id,
            product_id=i.product_id,
            product_name=i.product_name,
            variant_name=i.variant_name,
            price=i.price,
            quantity=i.quantity,
            image_url=i.image_url,
        ) for i in o.items],
    ) for o in orders]


@router.post("", response_model=OrderOut)
def create_order(
    data: OrderCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Create order from cart items or direct product selection."""
    if not data.items:
        raise HTTPException(status_code=400, detail="No items provided")

    total = Decimal("0")
    order_items = []

    for item in data.items:
        product = db.query(Product).filter(
            Product.id == item.product_id,
            Product.is_active == True,
        ).first()
        if not product:
            raise HTTPException(status_code=404, detail=f"Product {item.product_id} not found")

        variant = None
        if item.variant_id:
            variant = db.query(ProductVariant).filter(
                ProductVariant.id == item.variant_id,
                ProductVariant.product_id == item.product_id,
            ).first()
            if not variant:
                raise HTTPException(status_code=404, detail=f"Variant {item.variant_id} not found")

        price = (variant.retail_price if variant else product.retail_price)
        total += price * item.quantity

        # Get snapshot image
        img_url = None
        if product.images:
            for im in product.images:
                if im.is_primary:
                    img_url = im.image_url
                    break
            if not img_url:
                img_url = product.images[0].image_url

        order_items.append(OrderItem(
            product_id=item.product_id,
            variant_id=item.variant_id,
            product_name=product.name,
            variant_name=variant.variant_name if variant else None,
            price=price,
            quantity=item.quantity,
            image_url=img_url,
        ))

    # Generate order number
    order_no = f"NFR{datetime.now().strftime('%Y%m%d%H%M%S')}{uuid.uuid4().hex[:6].upper()}"

    order = Order(
        user_id=current_user.id,
        order_no=order_no,
        total_amount=total,
        shipping_name=data.shipping_name,
        shipping_phone=data.shipping_phone,
        shipping_address=data.shipping_address,
        note=data.note,
        created_at=datetime.now(),
    )
    db.add(order)
    db.flush()

    for oi in order_items:
        oi.order_id = order.id
        db.add(oi)

    # Clear cart items for this user
    db.query(CartItem).filter(CartItem.user_id == current_user.id).delete()

    db.commit()
    db.refresh(order)

    return OrderOut(
        id=order.id,
        order_no=order.order_no,
        total_amount=order.total_amount,
        status=order.status.value,
        shipping_name=order.shipping_name,
        shipping_phone=order.shipping_phone,
        shipping_address=order.shipping_address,
        created_at=order.created_at.isoformat() if order.created_at else None,
        items=[OrderItemOut(
            id=oi.id,
            product_id=oi.product_id,
            product_name=oi.product_name,
            variant_name=oi.variant_name,
            price=oi.price,
            quantity=oi.quantity,
            image_url=oi.image_url,
        ) for oi in order_items],
    )


@router.get("/{order_id}", response_model=OrderOut)
def get_order(
    order_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get order detail."""
    order = db.query(Order).options(joinedload(Order.items)).filter(
        Order.id == order_id,
        Order.user_id == current_user.id,
    ).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return OrderOut(
        id=order.id,
        order_no=order.order_no,
        total_amount=order.total_amount,
        status=order.status.value,
        shipping_name=order.shipping_name,
        shipping_phone=order.shipping_phone,
        shipping_address=order.shipping_address,
        created_at=order.created_at.isoformat() if order.created_at else None,
        items=[OrderItemOut(
            id=i.id,
            product_id=i.product_id,
            product_name=i.product_name,
            variant_name=i.variant_name,
            price=i.price,
            quantity=i.quantity,
            image_url=i.image_url,
        ) for i in order.items],
    )
