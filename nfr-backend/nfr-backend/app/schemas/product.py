from pydantic import BaseModel
from typing import List, Optional
from decimal import Decimal


class CategoryOut(BaseModel):
    id: int
    name: str
    parent_id: Optional[int] = None
    level: int
    children: List["CategoryOut"] = []

    class Config:
        from_attributes = True


class ProductImageOut(BaseModel):
    id: int
    image_url: str
    is_primary: bool

    class Config:
        from_attributes = True


class ProductVariantOut(BaseModel):
    id: int
    sku: str
    variant_name: Optional[str] = None
    retail_price: Decimal
    b2b_price: Optional[Decimal] = None
    stock: int

    class Config:
        from_attributes = True


class ProductAttributeOut(BaseModel):
    attr_name: str
    attr_value: str


class ActivityTag(BaseModel):
    type: str   # hot, new, bargain, full, promo
    label: str


class ProductOut(BaseModel):
    id: int
    name: str
    category_id: Optional[int] = None
    description: Optional[str] = None
    retail_price: Decimal
    b2b_price: Optional[Decimal] = None
    rating: Optional[Decimal] = None
    sales_count: int = 0
    images: List[ProductImageOut] = []
    variants: List[ProductVariantOut] = []
    attributes: List[ProductAttributeOut] = []
    tags: List[ActivityTag] = []
    discount: int = 0
    has_bargain: bool = False
    bargain_min_discount: Optional[int] = None
    has_full_reduction: bool = False
    full_reduction_threshold: Optional[int] = None
    full_reduction_amount: Optional[int] = None

    class Config:
        from_attributes = True


class ProductListOut(BaseModel):
    id: int
    name: str
    img: str  # primary image URL
    price: str  # formatted string
    original_price: Optional[str] = None
    discount: int = 0
    rating: Optional[Decimal] = None
    sold: int = 0
    tags: List[ActivityTag] = []
    has_bargain: bool = False
    bargain_min_discount: Optional[int] = None
    has_full_reduction: bool = False
    full_reduction_threshold: Optional[int] = None
    full_reduction_amount: Optional[int] = None
    has_group_buy: bool = False
    has_discount: bool = False


class FacetValue(BaseModel):
    value: str
    count: int


class FacetOut(BaseModel):
    name: str
    values: List[FacetValue]


class FilterFacetsOut(BaseModel):
    facets: List[FacetOut]
    total: int


class SearchResultOut(BaseModel):
    products: List[ProductListOut]
    total: int
    page: int
    page_size: int
    facets: List[FacetOut]


# Update forward refs
CategoryOut.model_rebuild()
