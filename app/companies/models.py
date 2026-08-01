"""
Ocean Bridge Trade - Company Model

A Company represents a buyer or supplier organization with evidence tracking.
"""
from datetime import datetime
from enum import Enum
from sqlalchemy import String, Text, Integer, DateTime, ForeignKey, Float, Boolean
from sqlalchemy.orm import relationship, Mapped, mapped_column
from app.database import Base


class CompanyRelationshipType(str, Enum):
    """Type of relationship with the company."""
    PROSPECT = "prospect"
    CONTACTED = "contacted"
    QUALIFIED = "qualified"
    PARTNER = "partner"
    RESTRICTED = "restricted"
    DECLINED = "declined"


class BuyerLeadMaturity(str, Enum):
    """
    Buyer lead maturity state machine per QWEN.md Section 5.
    
    Unverified → Pre-Qualified → Qualified → Transaction-Ready
    (with parallel Restricted/Declined states reachable from any stage)
    """
    UNVERIFIED = "unverified"
    PRE_QUALIFIED = "pre_qualified"
    QUALIFIED = "qualified"
    TRANSACTION_READY = "transaction_ready"
    RESTRICTED = "restricted"
    DECLINED = "declined"


class Company(Base):
    """
    Company entity - represents a buyer or supplier organization.
    
    Core fields per QWEN.md Section 4:
    - identity, evidence (trade data / website / product signals),
      confidence score, relationship type, qualification stage
    
    Includes audit trail fields for traceability.
    """
    __tablename__ = "companies"
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    
    # Core identity
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    domain: Mapped[str | None] = mapped_column(String(255), nullable=True, index=True)
    country: Mapped[str | None] = mapped_column(String(100), nullable=True)
    website_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    
    # Campaign association
    campaign_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("campaigns.id"), nullable=True, index=True)
    
    # Evidence tracking (raw evidence stored as JSON strings)
    evidence_trade_data: Mapped[str | None] = mapped_column(Text, nullable=True)
    evidence_website: Mapped[str | None] = mapped_column(Text, nullable=True)
    evidence_product_signals: Mapped[str | None] = mapped_column(Text, nullable=True)
    
    # Scoring & classification
    confidence_score: Mapped[float | None] = mapped_column(Float, nullable=True)
    relationship_type: Mapped[CompanyRelationshipType] = mapped_column(
        String(50), 
        default=CompanyRelationshipType.PROSPECT,
        nullable=False
    )
    
    # Buyer lead maturity state machine (enforced enum, not free-text)
    buyer_lead_maturity: Mapped[BuyerLeadMaturity] = mapped_column(
        String(50),
        default=BuyerLeadMaturity.UNVERIFIED,
        nullable=False
    )
    
    # Classification
    is_buyer: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    is_supplier: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    
    # Audit trail
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)  # 'system', 'human', or automation name
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    last_verified_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    
    # Relationships
    campaign = relationship("Campaign", back_populates="companies")
    contacts = relationship("Contact", back_populates="company", lazy="select", cascade="all, delete-orphan")
    
    def __repr__(self) -> str:
        return f"Company(id={self.id}, name='{self.name}', maturity={self.buyer_lead_maturity})"
