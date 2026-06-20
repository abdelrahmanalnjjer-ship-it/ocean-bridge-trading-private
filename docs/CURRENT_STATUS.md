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

## Current Label

`V1 Python Pilot — under independent validation`

## Still Unverified

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

Do not send outreach yet. The next build priority is one complete n8n workflow from candidate input through outreach draft and database logging.
