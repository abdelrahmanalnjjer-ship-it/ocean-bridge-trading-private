"""
Ocean Bridge Trade - Campaign Model

A Campaign defines a single search mission for buyer or supplier discovery.
"""
from datetime import datetime
from enum import Enum
from sqlalchemy import String, Text, Integer, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship, Mapped, mapped_column
from app.database import Base


class CampaignStatus(str, Enum):
    """Campaign lifecycle status."""
    DRAFT = "draft"
    ACTIVE = "active"
    PAUSED = "paused"
    COMPLETED = "completed"
    ARCHIVED = "archived"


class LeadType(str, Enum):
    """Type of leads the campaign targets."""
    BUYER = "buyer"
    SUPPLIER = "supplier"


class Campaign(Base):
    """
    Campaign entity - defines a single search mission.
    
    Core fields per QWEN.md Section 4:
    - industry, target country, lead type (buyer/supplier), product, 
      titles, signals, sources, budget, status
    """
    __tablename__ = "campaigns"
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    
    # Core identity
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    industry: Mapped[str | None] = mapped_column(String(100), nullable=True)
    target_country: Mapped[str | None] = mapped_column(String(100), nullable=True)
    lead_type: Mapped[LeadType] = mapped_column(String(50), nullable=False)
    product: Mapped[str | None] = mapped_column(String(255), nullable=True)
    
    # Targeting criteria
    titles: Mapped[str | None] = mapped_column(Text, nullable=True)  # JSON array of target titles
    signals: Mapped[str | None] = mapped_column(Text, nullable=True)  # JSON array of buying signals
    sources: Mapped[str | None] = mapped_column(Text, nullable=True)  # JSON array of data sources
    
    # Budget & status
    budget_usd: Mapped[float | None] = mapped_column(nullable=True)
    budget_spent_usd: Mapped[float] = mapped_column(default=0.0)
    status: Mapped[CampaignStatus] = mapped_column(String(50), default=CampaignStatus.DRAFT)
    
    # Timestamps
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    
    # Relationships
    companies = relationship("Company", back_populates="campaign", lazy="select")
    
    def __repr__(self) -> str:
        return f"Campaign(id={self.id}, name='{self.name}', status={self.status})"
