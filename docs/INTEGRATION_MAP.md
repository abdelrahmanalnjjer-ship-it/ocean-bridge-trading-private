# Integration Map

## GitHub — Backup and Source of Truth

Stores code, SQL migrations, n8n workflow JSON exports, tests, documentation, sample data, and recovery instructions.

Must not store production credentials, database passwords, service-account files, real `.env`, private supplier identity exports, or unrestricted customer data dumps.

## Neon PostgreSQL — Database Center

Stores campaigns, campaign runs, source records, companies, evidence, contacts, outreach drafts, buyer requirements, supplier offers, matches, opportunities, activities, costs, logs, and exceptions.

## n8n — Automation Center

Controls schedules and webhooks, source ingestion, website crawling, provider calls, database writes, retries, notifications, drafting, export, and pipeline transitions.

## Apify

Use for search-result collection, official website crawling, expo or directory extraction, and public contact-page extraction.

## Apollo / Prospeo

Use only after buyer relevance is proven.

```text
company confidence >= threshold
AND identity confirmed
AND buyer relevance supported
```

## NVIDIA / Hugging Face

NVIDIA: structured extraction, multilingual classification, RFQ extraction, and outreach drafting.

Hugging Face: embeddings, reranking, translation, similarity, and backup inference.

## Email Verification

```text
discovered
→ syntax_valid
→ domain_valid
→ mailbox_verified / risky / invalid / unknown
```

## Sending Mailbox

Recommended: `sales@oceanbridge-trading.com` with SPF, DKIM, DMARC, daily caps, bounce handling, suppression, and opt-out handling.
