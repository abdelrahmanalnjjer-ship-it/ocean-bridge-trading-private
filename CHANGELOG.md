# Changelog

## 2026-06-27

### Added

- Workflows 09–14 for approvals, RFQs, sourcing, quotations, deal control, commission tracking, and operations dashboard.
- Complete commercial opportunity fields on `ocean_bridge_campaign_companies`.
- Global PostgreSQL quotation sequence and unique quotation-number index.
- Synthetic test coverage for Workflows 09, 10, 12, and 13.
- Provider credential mapping for Apollo, MillionVerifier, and ScrapeGraphAI.
- Read-only database schema audit and cleanup plan.

### Changed

- Verification state moved to `ocean_bridge_contacts`.
- Campaign send controls moved to `ocean_bridge_campaigns`.
- Expo workflow moved to shared collection-run/source tables.
- ScrapeGraph target design changed to one request/result record.
- Outreach templates use safe `[[...]]` merge markers.
- Send gate now accepts only normalized `verified_valid` status.

### Verified current state

- 3 campaigns.
- 142 companies.
- 56 campaign-company opportunities.
- 2 contacts.
- 0 verified-valid contacts.
- 0 emails sent.
- 0 real RFQs, quotations, or deals.
- 28 Ocean Bridge tables; 7 identified for safe removal.

### Database cleanup completed

- Reduced Ocean Bridge tables from 28 to 21.
- Removed 4 migrated/empty duplicate tables.
- Archived 7 NVIDIA runs, 32 queue rows, and 13 result rows into cost-event metadata.
- Removed all 3 NVIDIA pilot tables.
- Rebuilt the NVIDIA reconciliation view on top of archived cost events.
- Archived the audit and one-time cleanup workflows.

### Pending

- Finish provider worker wiring and one-record paid tests.
- Add webhook authentication.
- Connect mailbox reply ingestion and sender last.

## 2026-06-24

### Changed

- Migrated development from the old n8n workspace to n8n2.
- Connected and tested Neon PostgreSQL.
- Replaced three-product hardcoding with catalog-driven selection.
- Added `__ALL_ACTIVE__` support and linked 33 active products.
- Generated English and Chinese search queries.
- Added provider cost logging and campaign budget controls.
- Added Expo ingestion and deterministic website crawling.
