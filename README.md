# Ocean Bridge Trading — China Seafood Buyer Engine

Private source-of-truth repository for the China seafood buyer automation project.

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

## Current Status

- Python/SQL pilot exists.
- Neon is active.
- Live n8n execution is not yet proven.
- Automatic outreach remains disabled until evidence quality, email verification, retry handling, and sending controls pass testing.
- Current label: `V1 Python Pilot — under independent validation`.

## Documentation

See the `docs/` folder for scope, architecture, integrations, n8n recovery, current status, security, and disaster recovery.

## Security

Never commit real `.env` files, API keys, database passwords, service-account files, or n8n credentials.

Internal use only — Ocean Bridge Trading.
