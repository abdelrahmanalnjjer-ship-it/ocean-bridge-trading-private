# Ocean Bridge Trading — China Seafood Buyer Engine

Private source-of-truth repository for the China seafood buyer automation project.

**Last repository audit:** 23 June 2026  
**Canonical branch:** `main`

## V1 Goal

Build an n8n-first workflow that takes a campaign input and automatically discovers Chinese seafood buyers, normalizes and deduplicates records, crawls public sources, extracts evidence, finds contacts, verifies emails, scores leads, drafts outreach, follows up, monitors replies, and alerts the user when a quotation is requested.

## Business Scope

- Target buyers: any legitimate Chinese commercial buyer able to import, buy, distribute, process, wholesale, or resell seafood from Oman.
- Weak digital presence is not a rejection reason; phone-only and WeChat-first businesses are included.
- Product scope: all seafood legally exportable from Oman and relevant to China.
- Campaigns focus on active seasonal products.
- Minimum commercial quantity: one container.
- No minimum company size, revenue, or commission threshold for V1.

## V1 Boundary

V1 ends when a buyer requests a quotation. Supplier pricing, negotiation, documents, commission protection, and shipment remain manual for now.

## Core Stack

GitHub, Neon PostgreSQL, n8n, Python, Apify, Apollo/Prospeo, MillionVerifier, NVIDIA, and Hugging Face.

## Current Verified Status

- Neon PostgreSQL is active.
- The pilot database contains 36 companies: 18 Hot and 18 Warm.
- The pilot contains 25 contacts, including 18 with email and 19 with phone.
- There are 18 outreach drafts; none are approved or sent.
- Workflow 01, `workflows/n8n/01-campaign-icp-builder.json`, is committed as a credential-free draft.
- Workflow 01 builds campaign settings, validates inputs, creates bilingual ICP/search plans, applies provider cost controls, and keeps automatic sending disabled.
- Live n8n import and end-to-end execution are not yet proven.
- The full Python scripts, SQL migrations, test suite, campaign files, and remaining workflow exports are not yet fully backed up in this repository.
- Current label: `V1 Python Pilot — under independent validation`.

## Operational Guardrail

Do not activate autonomous outreach yet. Evidence quality, mailbox-level email verification, retry handling, controlled failure recovery, sending controls, reply monitoring, and RFQ extraction must pass testing first.

## Next Build Priority

Connect Workflow 01 to Neon and prove one complete controlled path:

`campaign input → validation → ICP/search plan → database logging → outreach draft`

## Documentation

See the `docs/` folder for scope, architecture, integrations, n8n recovery, current status, security, disaster recovery, and repository backup status.

## Security

Never commit real `.env` files, API keys, database passwords, service-account files, or n8n credentials.

Internal use only — Ocean Bridge Trading.
