# CrowdSpark Lead Engine V1

Current implementation snapshot for the Ocean Bridge Trading lead-to-deal engine.

**Snapshot date:** 2026-06-27  
**Runtime:** n8n Cloud + PostgreSQL (Neon)  
**Project:** Abdelrahman Elnaggar personal n8n project

## Current operating model

CrowdSpark is a demand-first B2B seafood sourcing engine:

```text
Product intelligence
→ campaign and ICP
→ company discovery
→ website evidence extraction
→ value scoring
→ public contact capture
→ optional ScrapeGraph fallback
→ optional Apollo enrichment
→ optional MillionVerifier verification
→ deterministic outreach draft
→ owner approval and send gate
→ buyer reply and RFQ intake
→ Oman sourcing request
→ supplier offer and quotation
→ deal, shipment, and commission tracking
```

## Safety state

- Automatic paid enrichment: disabled
- Automatic email verification: disabled
- Automatic ScrapeGraph execution: disabled
- Automatic email sending: disabled
- Campaigns with sending enabled: 0
- Emails sent: 0
- Real RFQs: 0
- Real quotations: 0
- Real deals: 0

## Current live data

- Campaigns: 3
- Companies: 142
- Campaign-company opportunities: 56
- Contacts: 2
- Verified-valid contacts: 0
- ScrapeGraph queue: 2
- Product intelligence records: 33
- Search jobs: 238
- Cost events: 234
- PostgreSQL tables: 21 (reduced from 28)

## Provider credential mapping

| n8n credential | Provider |
|---|---|
| Query Auth account 3 | Apollo |
| Query Auth account 2 | MillionVerifier |
| Query Auth account | ScrapeGraphAI |

Credentials exist, but provider workers are not yet active and no provider API call was executed in the latest hardening phase.

## Documentation

- [Implementation status](docs/implementation-status-2026-06-27.md)
- [Workflow inventory](docs/workflows.md)
- [Database architecture](docs/database-schema.md)
- [Cleanup plan](docs/cleanup-plan.md)
- [Provider integration map](docs/provider-integrations.md)
- [Changelog](CHANGELOG.md)

## Database cleanup completed

The schema was reduced from 28 to 21 tables. Duplicate verification, send-control, Expo, ScrapeGraph-result, and NVIDIA pilot tables were removed after their data was migrated or archived.

## Important distinction

The system is **fully modeled** through commission tracking, but it is not yet production-live. Provider calls, authenticated webhooks, mailbox reply ingestion, and email sending still require controlled activation and testing.
