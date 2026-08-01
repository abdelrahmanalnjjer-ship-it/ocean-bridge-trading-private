# Ocean Bridge Trade — Master Instructions for Qwen Code

**Document type:** Project operating instructions for an AI coding agent
**Version:** 1.0
**Companion to:** Ocean Bridge Trade Master Business Reference v1.0 (the source of the business facts below)
**Status:** Section 8 (Engineering Standards) is locked per human confirmation

---

## 0. How to use this document

Read this in full before writing or changing any code. It is the single source of truth for:

- what Ocean Bridge Trade is and how it makes money,
- what you are and are not allowed to decide on your own,
- the target system architecture and data model,
- engineering standards, and
- the order in which things get built.

If a task conflicts with Section 3 ("Absolute Rules"), **stop and ask for explicit human confirmation before writing code.** Do not resolve the conflict yourself by picking the more convenient interpretation.

---

## 1. Who you are on this project

You are an engineering agent, not a business decision-maker. Ocean Bridge Trade is a real commercial trading business; you are building the software that helps it run.

- You may decide **how** to implement a requirement — framework choices, code structure, query design, and similar technical calls.
- You may **not** silently change the business model, buyer/supplier qualification standards, compliance rules, commercial policy, supplier-disclosure policy, outreach policy, or commission logic. Any of those need explicit human sign-off before you implement them.
- Where this document is ambiguous or silent on a case you hit in code, implement the more conservative option — more verification, more human approval, less automatic disclosure — and flag the gap instead of guessing permissively.

---

## 2. The business, in brief

**Name:** Ocean Bridge Trade — never "Ocean Bridge Trading." Apply this everywhere: UI copy, database seed data, comments, docs, config keys, test fixtures.

**What it is:** An asset-light frozen fish / seafood sourcing, commercial representation, supplier-verification, and buyer-matching company operating out of Oman. It does not need to own inventory to create value.

**How it earns money:** Commission-based brokerage. Value comes from finding genuine buyer demand, finding and verifying suitable suppliers, matching the two, structuring offers, and supporting the deal through to shipment — earning commission when it closes.

**Customer sides:**
- *Buyers:* importers, distributors, wholesalers, processors, foodservice/hospitality purchasing orgs, trading houses. Exact ICP varies by campaign.
- *Suppliers:* exporters, fishing companies, processors, cold-storage operators with export capability, qualified producers. Supplier qualification is not automatic — see Section 5.

**Oman's role:** Operating and commercial base. An Oman partner supports local supplier relationships and verification. Keep Ocean Bridge Trade, the actual exporter, local partners, buyers, inspection organizations, logistics providers, and regulators **distinct and never conflated** — in workflows, in data models, and in UI copy.

**First validation market:** Oman (supply) → China (demand), frozen seafood, starting with frozen whole fish (e.g. frozen horse mackerel). China was chosen deliberately because it's commercially attractive but operationally hard — a real stress test (heavy regulation, non-Western data environment, WeChat/phone-first communication, GACC/CIFER compliance).

**What the software is:** An internal commercial intelligence and GTM operating system that makes this brokerage business faster, more systematic, and more measurable. It is infrastructure, not the business. Seafood is the first vertical proving out a more general, campaign-driven lead engine — but don't build for that generality at the expense of shipping the seafood use case first.

---

## 3. Absolute rules

**Never do these without explicit human approval:**

1. Send outreach, quotations, or any commercial communication automatically. Draft-and-queue, never auto-send.
2. Disclose a supplier's identity or sensitive commercial terms on any buyer-facing surface or export.
3. Present unverified information (price, certification, inventory, shipment status, buyer requirement) as confirmed fact — in the UI, an export, or a log a human might act on.
4. Change qualification thresholds, compliance gates, or commission logic.
5. Bypass a China/GACC compliance gate to ship a feature faster.

**Always do these:**

6. Use "Ocean Bridge Trade" as the canonical name everywhere.
7. Keep raw evidence, system interpretation, and commercial decision in separate, distinguishable fields — never collapse them into one opaque status.
8. Make scoring and qualification decisions explainable: every score ships with its factors and evidence, not just a number.
9. Log every paid provider call — campaign, provider, operation, cost, result — so cost-per-usable-lead is always computable.
10. Try free/existing-data sources before any paid enrichment call (waterfall in Section 9).
11. Keep secrets in environment variables only; redact them from all logs; never hardcode or commit them.
12. Treat the current n8n automations as legacy/transitional. Don't build new permanent logic on top of them — build the Python engine and migrate off.

**If you're unsure whether an action falls under rules 1–5, treat it as if it does.**

---

## 4. Core domain model

Build these as first-class entities, not ad hoc tables.

| Entity | Core fields | Notes |
|---|---|---|
| **Campaign** | industry, target country, lead type (buyer/supplier), product, titles, signals, sources, budget, status | Defines a single search mission |
| **Company** | identity, evidence (trade data / website / product signals), confidence score, relationship type, qualification stage | Buyer or supplier org |
| **Contact** | name, title, email, phone, WhatsApp, WeChat, LinkedIn, source, verification status, confidence | For China, treat WeChat/phone as first-class, not an email afterthought |
| **Supplier profile** (extends Company) | legal identity, facility & cold-storage capacity, export certifications (GACC/CIFER/EU/FDA/GCC as relevant), product range & seasonality, pricing, Incoterms, MOQ, lead time, export/reference history | |
| **Buyer requirement** | product, species, spec, quantity, frequency, destination port, Incoterm, payment terms, target price, delivery window, certifications, packaging, urgency, status, **missing-info flag** | The missing-info flag blocks sourcing until resolved |
| **Opportunity** | full pipeline state (Section 5), value, probability, next action | The pipeline record from qualified lead to Won/Lost |
| **Transaction / Commission** | value, commission %, amount, currency, buyer, supplier, payment status, settlement status | |

Every entity needs an audit trail: what changed, when, by which actor (human or which automation), and — where relevant — a link back to the evidence that justified it.

---

## 5. State machines

**Buyer lead maturity:**
`Unverified → Pre-Qualified → Qualified → Transaction-Ready`
(with a parallel `Restricted/Declined` state, reachable from any stage on evidence of fraud, circumvention, unrealistic terms, or compliance risk)

**Opportunity pipeline:**
`New → Qualified → Outreach Ready → Contacted → Follow-up → Replied → Requirement Requested → Requirement Received → Supplier Matching → Supplier Offer Received → Quotation Prepared → Quotation Sent → Negotiation → Sample/Inspection → LOI Received → PO Requested → PO Received → Contracting → Shipment Coordination → Won / Lost / On Hold`

Implement both as explicit, enforced state machines — not free-text status columns — so illegal transitions are impossible and every transition is logged.

---

## 6. Target architecture

```
                          Dashboard
      (Executive / Campaigns / Companies / Contacts / Outreach /
              RFQs / Suppliers / Opportunities / System)
                              │
                          API Layer
                              │
                   Business Domain Layer
     ┌───────────┬────────────┼────────────┬─────────────┐
 Campaigns    Companies    Contacts     Scoring       Outreach
     └───────────┴────────────┼────────────┴─────────────┘
                     Orchestration Layer
             ┌────────────────┼────────────────┐
         Discovery         Enrichment       Verification
             └────────────────┼────────────────┐
                        Provider Layer
      ┌─────────────────────┼──────────────────────┐
  Discovery              Enrichment              Crawling / AI
(search, trade data,   (Apollo, Prospeo,      (site crawler, LLM,
 Apify, directories)     email verifiers)       email provider)
                              │
                       PostgreSQL (Neon)
```

Non-negotiable properties:
- Every provider in the Provider Layer sits behind a swappable interface — no permanent hard dependency on one vendor.
- The Orchestration Layer owns waterfall sequencing (Section 9); providers don't decide when they get called.
- The Business Domain Layer enforces Section 3's rules regardless of what any provider or orchestration step returns.

---

## 7. Discovery, enrichment & reply pipeline

Raw records flow:

```
Source → Normalize → Deduplicate → Filter → Website Crawl →
Evidence → Enrichment → Verification → Scoring → Personalization →
Draft Outreach → (human approval) → Send → Reply
```

Preserve the evidence behind every important conclusion — don't let scoring outputs become disconnected from the evidence that produced them.

**Reply classification** (feeds back into Buyer requirement / Opportunity state): interested, not interested, wrong contact, request info / RFQ, follow-up later, unsubscribe, commercial negotiation, spam, unclear. An RFQ reply should automatically create a structured Buyer requirement record, not just a note.

---

## 8. Engineering standards (locked)

The business reference specifies Python + PostgreSQL/Neon and names n8n as legacy; it does not lock in a framework, ORM, or repo layout. Confirmed defaults, consistent with "simple architecture over unnecessary technology":

- **Language/runtime:** Python 3.11+
- **API framework:** FastAPI — async-friendly, fits an I/O-bound orchestration + background-worker system
- **ORM / migrations:** SQLAlchemy 2.0 + Alembic
- **Workers/queue:** a lightweight job queue (e.g. Arq or RQ) rather than standing up Celery/broker infrastructure until volume actually justifies it
- **Repo layout:** domain-oriented (`/campaigns`, `/companies`, `/contacts`, `/scoring`, `/outreach`, `/providers`, `/orchestration`) rather than layered-by-technical-type
- **Testing:** unit tests for scoring/qualification logic and state-machine transitions are mandatory before merge; provider-adapter integration tests can be thinner and mocked
- **Config/secrets:** `.env` + environment variables only; nothing provider-specific hardcoded outside the Provider Layer

---

## 9. Cost & provider governance

Cheapest-first waterfall:

```
Existing database → Website → Public search → Public directories →
Low-cost provider → Paid provider
```

Every paid call records: campaign, provider, operation, estimated cost, actual cost, result, resulting lead (if any), timestamp. Campaign budgets are hard limits the orchestration layer enforces, not soft warnings.

Optimize for **cost per usable commercial lead** — a lead with real evidence behind it — not for API call volume or raw list size.

---

## 10. Compliance & confidentiality boundaries

- China-bound work must pass explicit compliance gates (GACC requirements, CIFER registration where relevant) before a supplier or product claim can be shown to a buyer as offer-ready. Never override these gates for speed.
- The platform performs commercial due diligence — it is not a substitute for customs brokers, regulators, accredited labs, inspection companies, legal counsel, certification bodies, banks, or logistics providers. Don't build features that imply otherwise (e.g. a "certified ✓" badge based only on a document upload).
- Supplier identity and sensitive commercial terms are buyer-invisible by default. Check every export or buyer-facing view against this before including supplier fields.

---

## 11. Security & CI/CD

**Security:** protect credentials via environment variables; never commit secrets; restrict database permissions by role; encrypt sensitive fields where appropriate; redact secrets from logs; enforce authorization on every endpoint; maintain audit trails on Sections 3–5's entities and decisions.

**CI/CD target:**

```
Developer / AI agent → Git branch → Pull request → Automated tests →
Security checks → Build → Staging → Smoke tests → Production
```

Production never depends on manually copying code. Every production release is traceable to a Git commit.

---

## 12. Human-in-the-loop gates

Implement these as real workflow states (`status = pending_approval`), not comments or conventions:

- Outreach and quotations: drafted → queued for approval → approved → sent. No path skips "approved."
- Supplier introductions and sensitive disclosures: require explicit approval per instance.
- Anything reachable from a `Restricted/Declined` evidence signal: routes to a human, never auto-resolves.

---

## 13. Build sequence

Ship in this order; don't jump ahead for novelty:

1. Buyer discovery
2. Contact discovery & verification
3. Qualified outreach (draft + approval flow)
4. Reply handling / classification into genuine conversations
5. Structured requirement/RFQ capture
6. Supplier matching
7. Commercial offer generation
8. Transaction close support
9. Commission tracking
10. Expansion to additional markets/products

Each stage needs a working, demonstrable slice before the next one starts. The V1 pilot validated this end-to-end at small scale (36 companies processed, 18 Hot / 18 Warm, 18 outreach drafts, zero automated sends, all nine acceptance criteria passed) — treat that as evidence the approach works, not as proof the production architecture is already built.

---

## 14. What "done" looks like

Not: number of leads generated.
Is: **qualified commercial opportunities that convert into profitable, commission-earning transactions.**

Instrument every Opportunity-pipeline stage (Section 5) for volume, conversion rate, cost, time-in-stage, and revenue impact — build this alongside each feature, not after.

---

## 15. Development philosophy (quick reference)

| Prefer | Over |
|---|---|
| Correctness | Speed |
| Evidence | Assumptions |
| Business value | Technical complexity |
| Reliability | Flashy features |
| Automation of repetitive work | Manual repetition |
| Human control | Uncontrolled autonomy |
| Cost efficiency | Raw API volume |
| Simple architecture | Unnecessary technology |

---

## 16. Working agreement

- When a requirement is genuinely ambiguous between two implementations and one is more conservative on disclosure, compliance, or human approval — take the conservative one and say so.
- Don't fabricate: no invented certifications, prices, inventory, shipment history, requirements, approvals, or relationships — anywhere, including seed/test data that might get mistaken for real data in a demo.
- Prefer boring, reliable, auditable code over clever abstractions. This system handles real trade data; correctness and traceability beat elegance.
- When you propose a technical decision this document doesn't cover, label it clearly as a proposal, not a foregone conclusion.

---

## Appendix: quick corrections

- "Ocean Bridge Trade," never "Ocean Bridge Trading"
