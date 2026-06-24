# Current Status

## Verified Live Neon Facts

- 36 companies in the campaign
- 18 Hot and 18 Warm
- 25 contacts
- 18 contacts with email
- 19 contacts with phone
- 18 contacts marked `verified_format`
- 1 contact marked `inferred_format`
- 6 contacts with missing email
- 18 outreach drafts
- 0 approved and 0 sent
- 32 source records, all marked `cleaned`
- 1 cost event totaling 15 cents
- 1 log row and no recorded error rows
- no duplicate normalized company names found in the `companies` table

## Corrected Pilot Counts

- 32 source records total
- 31 real companies from the pilot SQL
- 1 sample source record
- 36 companies total
- 31 real pilot companies
- 5 seed/sample companies

The earlier claim of 30 real companies was incorrect.

## 24 June 2026 Cost and Source Decisions

A separate reported run used about $100 of model credit for 53 raw company leads without completed employee enrichment. This is about $1.89 per raw lead and fails V1 economics.

The repository now includes:

- `database/migrations/20260624_001_cost_ledger.sql`
- `config/source-and-scoring-v1.json`
- updated cost, model, expo-first sourcing, scoring, and deduplication decisions

These files are committed but the migration has not yet been confirmed as applied to Neon. The cost ledger and hard budget gate are therefore not live controls yet.

Official seafood expo exhibitor data from the most recent five years is now the first sourcing priority. Expo participation increases data confidence but does not automatically prove current buyer intent.

V1 keeps simple company deduplication by normalized domain, otherwise normalized company name plus country. Multiple different contacts at one company are allowed and expected.

## Current Label

`V1 Python Pilot — under independent validation`

## Still Unverified

- historical provider usage explaining the reported $100 spend
- cost-ledger migration applied to Neon
- pre-call hard-budget check wired into every paid provider node
- reconciliation between Neon cost totals and provider dashboards
- negative-control test details
- classification precision and recall
- company-specific buyer evidence quality
- mailbox-level verification
- retry execution
- controlled failure recovery
- full n8n import and execution
- real crawler execution
- autonomous sending
- reply monitoring
- RFQ extraction
- production readiness

## Current Operational Decision

Do not add another unrestricted $100 credit and do not send outreach yet.

The next controlled build order is:

1. inspect provider usage history to identify the $100 consumption or expiration
2. apply and verify the cost-ledger migration in Neon
3. wire the budget check and cost-event insert around every paid provider call
4. use an isolated provider key/account for Ocean Bridge
5. run a maximum $5 test on 10–20 companies
6. reconcile Neon totals with the provider dashboard
7. continue Workflow 02 only after the totals match
