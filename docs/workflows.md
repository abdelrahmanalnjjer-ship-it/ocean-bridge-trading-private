# n8n Workflow Inventory

## Core workflows

| ID | Workflow | Status | Purpose |
|---|---|---|---|
| pAcgzEQx444Hhgyu | 00 — Seafood Product Intelligence Sync | Active | Product catalog normalization |
| LgOmL5dbyDMP5eeo | 01 — Ocean Bridge Campaign & ICP Builder | Active | Campaign, ICP, product selection |
| xcW41XFCCEg69MWY | 02 — Search and Company Collection | Active | Company discovery and search jobs |
| xcwE9hj1IcIqCJMp | 02A — Expo List Ingestion | Active | Expo source adapter |
| BQ9gQ1802yFilgAd | 03 — Website Crawling and Evidence Extraction | Active | Deterministic crawl and evidence |
| agy9Y1aLWol7lOGJ | 03B — ScrapeGraph Fallback Queue | Inactive | High-value fallback queue |
| 3RXw68oHsQxkHBkP | 04 — Enrichment Review and Approval | Inactive | Company value and action decision |
| S43KdPLbNTSafMHr | 05 — Contact and Email Enrichment Router | Inactive | Public contacts and enrichment routing |
| QlbjhKz1InMmW3mW | 06 — Email Verification Review | Inactive | Free email quality checks |
| 06ERLxRecnUsDk8q | 07 — Outreach Email Draft Builder | Inactive | Deterministic drafts |
| Nx7KdJoqVxGjXQbt | 08 — Email Send Approval Gate | Inactive | Final send safety rules |
| zTxEoFejRb1al2Dx | 09 — Owner Approval Control Center | Inactive | Owner decisions |
| 8MBTRl7x14GBu3Z2 | 10 — Buyer Reply and RFQ Intake | Inactive | Reply classification and RFQ capture |
| G7xurkKgQ1T4jThj | 11 — RFQ Qualification and Oman Sourcing Pack | Inactive | RFQ completeness and sourcing pack |
| Wo0gbZGoEDEyT8SL | 12 — Supplier Offer and Buyer Quotation | Inactive | Offer normalization and quotation |
| WEhDtxDTC8tWM85v | 13 — Deal and Commission Control | Inactive | Deal, shipment, commission state |
| 8erwhcXfIjdJb7zy | 14 — Owner Operations Dashboard | Inactive | Read-only operations summary |

## Maintenance / irrelevant workflows

| ID | Workflow | Decision |
|---|---|---|
| xbdQBfbsdM34mMoo | 98 — Database Schema Audit | Archived after cleanup snapshot |
| b1JBFS0PL96M0JX1 | Chat with the news | Archive; unrelated to CrowdSpark |

## Why the workflow count grew

The engine was built stage-by-stage for safety, testing, and cost control. Separate workflows prevented a provider mistake or send action from affecting the full pipeline. That was appropriate during development, but the visible list is now crowded.

## Target operating view

The current workflow count can be made easier to operate without rewriting working logic:

- Keep core workflows 00–14.
- Archive unrelated and one-time maintenance workflows.
- Use consistent tags: `CORE`, `MANUAL`, `PROVIDER`, `ADMIN`.
- Later merge only where operationally useful, not just to reduce the number.

## Archived one-time cleanup workflows

- 97A — Schema Consolidation
- 97B — Duplicate Table Cleanup
- 97C — NVIDIA Table Cleanup

These are retained only in archive for audit history and do not appear in the normal operating list.
