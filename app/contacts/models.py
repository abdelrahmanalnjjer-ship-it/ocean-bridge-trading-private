"""
Ocean Bridge Trade - Contact Model

A Contact represents an individual person at a company.
"""
from datetime import datetime
from enum import Enum
from sqlalchemy import String, Text, Integer, DateTime, ForeignKey, Float, Boolean
from sqlalchemy.orm import relationship, Mapped, mapped_column
from app.database import Base


class ContactVerificationStatus(str, Enum):
    """Contact verification status."""
    UNVERIFIED = "unverified"
    SYNTAX_VALID = "syntax_valid"
    DOMAIN_VERIFIED = "domain_verified"
    MAILBOX_VERIFIED = "mailbox_verified"
    BOUNCED = "bounced"
    INVALID = "invalid"


class Contact(Base):
    """
    Contact entity - represents an individual person at a company.
    
    Core fields per QWEN.md Section 4:
    - name, title, email, phone, WhatsApp, WeChat, LinkedIn,
      source, verification status, confidence
    
    For China, WeChat/phone are first-class citizens, not afterthoughts.
    """
    __tablename__ = "contacts"
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    
    # Core identity
    name: Mapped[str | None] = mapped_column(String(255), nullable=True)
    title: Mapped[str | None] = mapped_column(String(255), nullable=True)
    
    # Company association
    company_id: Mapped[int] = mapped_column(Integer, ForeignKey("companies.id"), nullable=False, index=True)
    
    # Contact channels (WeChat/phone as first-class for China market)
    email: Mapped[str | None] = mapped_column(String(255), nullable=True, index=True)
    phone: Mapped[str | None] = mapped_column(String(50), nullable=True)
    whatsapp: Mapped[str | None] = mapped_column(String(50), nullable=True)
    wechat: Mapped[str | None] = mapped_column(String(100), nullable=True)
    linkedin_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    
    # Source & verification
    source: Mapped[str | None] = mapped_column(String(100), nullable=True)  # e.g., 'website', 'apollo', 'manual'
    verification_status: Mapped[ContactVerificationStatus] = mapped_column(
        String(50),
        default=ContactVerificationStatus.UNVERIFIED,
        nullable=False
    )
    confidence_score: Mapped[float | None] = mapped_column(Float, nullable=True)
    
    # Evidence tracking
    evidence_source: Mapped[str | None] = mapped_column(Text, nullable=True)  # JSON of where contact was found
    
    # Audit trail
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    last_verified_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    
    # Relationships
    company = relationship("Company", back_populates="contacts")
    
    def __repr__(self) -> str:
        return f"Contact(id={self.id}, name='{self.name}', email='{self.email}')"
