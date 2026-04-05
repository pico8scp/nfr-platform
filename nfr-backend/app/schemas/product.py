from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class CategoryOut(BaseModel):
    id: int
    parent_id: Optional[int]
    name: str
    slug: str
    icon_url: str
    sort_order: int
    is_active: int
    children: List["CategoryOut"] = []

    class Config:
        from_attributes = True


class ProductImageOut(BaseModel):
    id: int
    url: str
    sort_order: int
    is_main: int

    class Config:
        from_attributes = True


class VariantOut(BaseModel):
    id: int
    sku: str
    specs: Optional[str]
    retail_price: int
    b2b_price: int
    b2b_min_qty: int
    weight: int
    stock_qty: int
    is_active: int

    @property
    def specs_dict(self) -> dict:
        import json
        if self.specs:
            try:
                return json.loads(self.specs)
            except:
                pass
        return {}

    @property
    def retail_price_yuan(self) -> float:
        return self.retail_price / 100

    @property
    def b2b_price_yuan(self) -> float:
        return self.b2b_price / 100

    class Config:
        from_attributes = True


class ActivityTag(BaseModel):
    type: str
    label: str
    icon: Optional[str] = None


class ProductOut(BaseModel):
    id: int
    category_id: Optional[int]
    source: str
    name: str
    brand: str
    material: str
    unit: str
    is_active: int
    created_at: Optional[datetime]
    images: List[ProductImageOut] = []
    variants: List[VariantOut] = []
    tags: List[ActivityTag] = []

    @property
    def main_image(self) -> str:
        for img in self.images:
            if img.is_main:
                return img.url
        return self.images[0].url if self.images else ""

    @property
    def min_retail_price(self) -> float:
        if not self.variants:
            return 0
        return min(v.retail_price_yuan for v in self.variants if v.is_active)

    @property
    def min_b2b_price(self) -> float:
        if not self.variants:
            return 0
        return min(v.b2b_price_yuan for v in self.variants if v.is_active)

    class Config:
        from_attributes = True


class ProductListOut(BaseModel):
    id: int
    category_id: Optional[int]
    source: str
    name: str
    brand: str
    material: str
    is_active: int
    main_image: str = ""
    min_retail_price: float = 0
    min_b2b_price: float = 0
    tags: List[ActivityTag] = []
    images: List[ProductImageOut] = []

    class Config:
        from_attributes = True


class FacetValueOut(BaseModel):
    value: str
    count: int


class FacetOut(BaseModel):
    name: str
    values: List[FacetValueOut]


class FilterFacetsOut(BaseModel):
    facets: List[FacetOut]
    min_price: float = 0
    max_price: float = 0


class SearchResultOut(BaseModel):
    products: List[ProductListOut]
    total: int
    page: int
    page_size: int
    facets: FilterFacetsOut
