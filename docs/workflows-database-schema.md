# Ocean Bridge Trading — Workflows, Nodes, and Database Schema

**System snapshot:** 2026-06-23  
**n8n project:** `sI3cPBYW0WkNuFcO`

This document describes the three Ocean Bridge workflows currently reported as deployed and the ten PostgreSQL tables directly declared and used by those workflows. It is not a complete inventory of every table that may exist in Neon.

## 1. System overview

| Workflow | Status | Nodes | Responsibility |
|---|---:|---:|---|
| 00 — Seafood Product Intelligence Sync | Inactive | 6 | Normalize and persist seafood product intelligence |
| 01 — Ocean Bridge Campaign & ICP Builder | Active, internal/manual | 15 | Build campaigns, product links, ICPs, and multilingual search plans |
| 02 — Search and Company Collection | Active, internal/manual | 19 | Execute tracked searches, normalize companies, deduplicate, score, and save evidence |

```text
Product catalog
  → Workflow 00: product intelligence
  → Workflow 01: campaign + ICP + search plan
  → Workflow 02: company candidates + evidence
  → Planned Workflow 03: website crawling + buyer classification
```

Automatic outreach is disabled. The latest reported collection contains 52 unique company candidates, 247 raw candidates, and 117 source records. These are candidates, not verified buyers.

## 2. Workflow 00 — Seafood Product Intelligence Sync

**ID:** `tjyNVdli2GDekLOQ`  
**Status:** Inactive

### Purpose

Accept a product catalog, normalize product names and market attributes, then upsert product intelligence into Neon.

### Nodes

1. **Receive Product Catalog** — webhook input for `catalog` or `catalog_b64`; currently unauthenticated.
2. **Normalize Product Catalog** — validates up to 100 products and derives product keys, families, aliases, Chinese terms, ports, hubs, risks, and verification status.
3. **Ensure Product Intelligence Table** — creates the product table and indexes.
4. **Upsert Product Intelligence** — idempotent upsert by `product_key`.
5. **Verify Product Catalog** — returns active-product and quality totals.
6. **Product Sync Completed** — returns the completion summary.

### Guardrail

Keep this workflow inactive until the webhook has authentication.

## 3. Workflow 01 — Campaign & ICP Builder

**ID:** `OI6bDJTZ2iBX4Vvn`  
**Status:** Active, internal/manual

### Current campaign template

- Market: China
- Products: horse mackerel, sardines, shrimp
- Target leads: 1,000
- Maximum cost per contactable lead: USD 0.50
- Minimum order: one container
- Phone-only and WeChat-first buyers: included
- Source strategy: public-first
- Automatic sending: disabled

### Nodes

1. Start Campaign Build
2. Called by Another Workflow
3. Campaign Settings
4. Validate & Normalize
5. Prepare Product Lookup
6. Load Product Intelligence
7. Attach Product Intelligence
8. Build ICP & Search Plan
9. Apply Cost & Safety Rules
10. Campaign Build Result
11. Prepare Neon Persistence
12. Ensure Neon Tables
13. Save Campaign & Search Plan
14. Save Campaign Product Links
15. Campaign Build Completed

### Buyer segments

Importer, processor, distributor, wholesaler, trading company, cold-storage buyer, food-service supplier, and regional seafood trader.

### Rejection rule

Reject only clearly irrelevant, consumer-only, invalid, duplicate, fraudulent, suspicious, or commercially incapable records. A weak website alone is not a rejection reason.

## 4. Workflow 02 — Search and Company Collection

**ID:** `sdH96TyffJ5nlFUl`  
**Status:** Active, internal/manual

### Input controls

```json
{
  "campaign_key": "optional",
  "live_collection": false,
  "pilot_limit": 100,
  "query_limit": 12,
  "results_per_query": 10
}
```

Limits: `pilot_limit` 1–100, `query_limit` 1–30, and `results_per_query` 1–10. Dry-run mode prevents paid research.

### Nodes

1. Start Controlled Pilot
2. Called by Workflow 01
3. Normalize Collection Request
4. Ensure Run Tables
5. Ensure Company Tables
6. Load Ready Campaign
7. Prepare Query Jobs
8. Register Query Job
9. Check Pilot Capacity
10. Prepare Query Research
11. Run Live Research?
12. Create Safe Dry Run Result
13. OpenAI Web Research Model
14. Research Seafood Companies
15. Normalize Candidate Companies
16. Save Candidate Batch
17. Await All Query Results
18. Finalize Collection Run
19. Collection Run Completed

### Company identity

- Official domain available: `domain:<domain>`
- Directory-only company: `name:<normalized-name>|<country>|<city>`

This prevents many companies listed on the same directory domain from collapsing into one record.

### Collection-stage score

Points can be added for explicit buyer likelihood, importing/processing/distribution/wholesale/trading/cold-storage/food-service evidence, seafood relevance, China relevance, a company domain, and a selected-product match.

- Score 55 or above → `candidate`
- Below 55 → `manual_review`

## 5. Database schema

The executable DDL is stored in `database/current_schema.sql`.

### Tables

1. **`ocean_bridge_product_intelligence`** — master product catalog and market intelligence; unique `product_key`; JSONB aliases, ports, hubs, markets, and compliance risks.
2. **`ocean_bridge_campaigns`** — campaign settings, ICP, safety payload, target leads, and cost ceiling; unique `campaign_key`.
3. **`ocean_bridge_search_plans`** — one search plan per campaign; queries, cities, source order, and full payload.
4. **`ocean_bridge_campaign_products`** — links requested campaign products to product-intelligence records.
5. **`ocean_bridge_collection_runs`** — one tracked Workflow 02 execution, limits, status, provider usage, and totals.
6. **`ocean_bridge_search_jobs`** — one job per search query; lifecycle, counts, provider, cost state, and errors.
7. **`ocean_bridge_companies`** — canonical company master; domain is indexed but intentionally not unique.
8. **`ocean_bridge_company_sources`** — provenance and evidence per company discovery; unique `(company_id, source_hash)`.
9. **`ocean_bridge_campaign_companies`** — many-to-many campaign/company link with score, status, products, and query.
10. **`ocean_bridge_collection_cost_events`** — provider usage and future cost ledger.

### Relationships

```text
ocean_bridge_product_intelligence
  ← ocean_bridge_campaign_products
  → ocean_bridge_campaigns
      ├─ ocean_bridge_search_plans
      ├─ ocean_bridge_collection_runs
      ├─ ocean_bridge_search_jobs
      ├─ ocean_bridge_company_sources
      └─ ocean_bridge_campaign_companies ↔ ocean_bridge_companies

ocean_bridge_collection_runs
      ├─ ocean_bridge_search_jobs
      ├─ ocean_bridge_company_sources
      ├─ ocean_bridge_campaign_companies
      └─ ocean_bridge_collection_cost_events
```

Campaign and run foreign keys generally use `ON DELETE CASCADE`.

## 6. Current limitations

1. Workflow 00 webhook has no authentication.
2. Workflow 01 settings are hardcoded rather than dynamic validated input.
3. Workflow 02's description mentions Apify fallback, but the active graph reportedly has no Apify node.
4. n8n-managed OpenAI free credits are exhausted; live AI search needs a user-owned credential or replacement provider.
5. Cost events are logged but remain `unpriced`; `estimated_cost_usd` is null.
6. `query_hash` is currently an encoded value rather than SHA-256.
7. DDL is embedded in workflows; migration files should become the source of truth.
8. Current records are candidates and require website and commercial-relevance validation.

## 7. Not built yet

- Website crawling and page snapshots
- Final buyer classification
- Decision-maker and contact discovery
- Email, phone, and WeChat verification
- Contactability scoring
- Human approval queue
- Outreach and reply tracking
- Quotes, deals, commissions, and shipment workflows

## 8. Recommended next workflows

| Workflow | Responsibility |
|---|---|
| 03 — Website Crawling & Buyer Classification | Validate websites, collect evidence, classify buyer roles, and reject irrelevant companies |
| 04 — Contact Discovery & Verification | Find decision-makers and verify contact channels |
| 05 — Lead Scoring & Human Approval | Combine fit, evidence, and contactability into an approval queue |
| 06 — Outreach & Reply Tracking | Send only approved messages and track responses while commercial commitments remain manual |
