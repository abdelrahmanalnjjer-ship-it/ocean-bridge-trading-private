# Ocean Bridge Lead Engine — Current System Status

**Updated:** 2026-06-23

## Deployed workflows

| Workflow | n8n ID | Status | Nodes | Responsibility |
|---|---|---:|---:|---|
| 00 — Seafood Product Intelligence Sync | `tjyNVdli2GDekLOQ` | Inactive | 6 | Normalize and store seafood product intelligence |
| 01 — Ocean Bridge Campaign & ICP Builder | `OI6bDJTZ2iBX4Vvn` | Active, internal/manual | 15 | Build campaign, ICP, product links, and multilingual search plan |
| 02 — Search and Company Collection | `sdH96TyffJ5nlFUl` | Active, internal/manual | 19 | Search, normalize, deduplicate, score, and store company candidates |

Total deployed Ocean Bridge nodes: **40**.

## Current campaign state

- Market: China
- Products: horse mackerel, sardines, shrimp
- Minimum order: one container
- Automatic outreach: disabled
- Human approval required for outreach, quotations, and commercial commitments
- Saved company candidates: 52
- Raw candidates collected in the latest successful full search: 247
- Evidence/source records: 117
- Candidate records are not yet verified buyers

## Database scope

The active workflows directly use these tables:

1. `ocean_bridge_product_intelligence`
2. `ocean_bridge_campaigns`
3. `ocean_bridge_search_plans`
4. `ocean_bridge_campaign_products`
5. `ocean_bridge_collection_runs`
6. `ocean_bridge_search_jobs`
7. `ocean_bridge_companies`
8. `ocean_bridge_company_sources`
9. `ocean_bridge_campaign_companies`
10. `ocean_bridge_collection_cost_events`

## Current limitations

- Workflow 00 has an unauthenticated webhook and must remain inactive until secured.
- Workflow 01 still uses hardcoded campaign settings.
- Workflow 02 is internal-only; the temporary public webhook was removed.
- The n8n-managed OpenAI free credits are exhausted.
- Workflow 02 currently has no Apify node, even though an older description still mentions Apify fallback.
- Cost events are logged but not priced.
- Workflow 03 is not yet deployed.

## Next planned workflow

`03 — Website Crawling & Buyer Classification`

It should validate company websites and commercial relevance before contact discovery or outreach.
