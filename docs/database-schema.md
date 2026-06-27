# PostgreSQL Database Architecture

**Snapshot date:** 2026-06-27  
**Current Ocean Bridge tables:** 21 (reduced from 28)

## Core tables retained

### Product and campaign

- `ocean_bridge_product_intelligence`
- `ocean_bridge_campaigns`
- `ocean_bridge_campaign_products`
- `ocean_bridge_campaign_budgets`
- `ocean_bridge_search_plans`

### Discovery and evidence

- `ocean_bridge_collection_runs`
- `ocean_bridge_search_jobs`
- `ocean_bridge_companies`
- `ocean_bridge_campaign_companies`
- `ocean_bridge_company_sources`
- `ocean_bridge_company_crawls`

### Contacts and outreach

- `ocean_bridge_employee_enrichment_queue`
- `ocean_bridge_contacts`
- `ocean_bridge_disposable_domains`
- `ocean_bridge_email_templates`
- `ocean_bridge_outreach_drafts`
- `ocean_bridge_outreach_events`
- `ocean_bridge_suppression_list`

### Cost and provider controls

- `ocean_bridge_cost_events`
- `ocean_bridge_provider_rates`
- `ocean_bridge_scrapegraph_queue`

## Cleanup completed

The following seven tables were removed after their useful state was migrated or archived:

1. `ocean_bridge_campaign_send_controls`
   - Send controls now live on `ocean_bridge_campaigns`.
2. `ocean_bridge_email_verification_queue`
   - Verification state now lives on `ocean_bridge_contacts`.
3. `ocean_bridge_expo_ingestions`
   - Expo tracking now uses shared collection-run and source-evidence tables.
4. `ocean_bridge_scrapegraph_results`
   - Result payload, status, and processing time now live on `ocean_bridge_scrapegraph_queue`.
5. `ocean_bridge_nvidia_pilot_runs`
6. `ocean_bridge_nvidia_pilot_queue`
7. `ocean_bridge_nvidia_pilot_results`
   - Historical NVIDIA pilot data was archived into `ocean_bridge_cost_events.metadata` before removal.

## Preserved compatibility

`ocean_bridge_nvidia_reconciliation_summary` remains available as a view over archived cost-event metadata.

## Why small or empty tables remain

- `ocean_bridge_suppression_list` is essential for future unsubscribe and compliance handling.
- `ocean_bridge_outreach_events` is the future send and delivery audit trail.
- `ocean_bridge_email_templates` intentionally contains only the required English and Chinese templates.
- `ocean_bridge_contacts` remains small because only public, relevant contacts are retained.
