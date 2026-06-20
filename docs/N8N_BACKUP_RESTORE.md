# n8n Backup and Restore Guide

## Backup Checklist

For every n8n workflow:

1. Use a numeric workflow name.
2. Export the workflow as JSON.
3. Save it under `workflows/n8n/`.
4. Remove or confirm the absence of embedded secrets.
5. Commit the JSON to this private repository.
6. Document required credentials and environment variables.
7. Record trigger, inputs, outputs, tables touched, and status changes.
8. Add a test fixture or pin-data example.
9. Record the last successful test date.
10. Keep production workflows inactive in backup copies.

## Required Workflow Files

```text
01-campaign-icp-builder.json
02-csv-source-ingestion.json
03-search-source-ingestion.json
04-cleaning-deduplication.json
05-website-crawler.json
06-pre-scoring.json
07-contact-enrichment.json
08-contact-verification.json
09-final-scoring.json
10-personalization.json
11-outreach-review-export.json
12-buyer-requirement-intake.json
13-supplier-offer-intake.json
14-buyer-supplier-matching.json
15-quotation-preparation.json
16-reporting-costs.json
```

## Restore Procedure

1. Restore or reconnect Neon.
2. Create the n8n instance and configure timezone, webhook URL, HTTPS, and a new encryption key.
3. Recreate credentials inside n8n for Neon, Apify, Apollo, Prospeo, NVIDIA, Hugging Face, MillionVerifier, Google Sheets, and email.
4. Import workflows in numeric order and keep them inactive.
5. Attach credentials and verify node versions, webhook paths, table names, expressions, and environment variables.
6. Test each workflow with sample data.
7. Verify database writes, logs, costs, retries, exceptions, and that no outbound email was sent.
8. Activate gradually only after dependencies pass.

Recommended activation order:

```text
01 → 02 → 04 → 05 → 06 → 07 → 08 → 09 → 10 → 11
then
12 → 13 → 14 → 15 → 16
```

## Monthly Recovery Test

- export all active workflows
- compare them with GitHub versions
- confirm the credential inventory
- restore one workflow into a test project
- run it with sample data
- confirm expected database changes
