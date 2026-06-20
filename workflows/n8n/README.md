# n8n Workflow Exports

Place the 16 credential-free n8n workflow JSON exports in this folder.

Required naming:

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

Each workflow must document its trigger, required credentials, input, output, Neon tables touched, status transitions, retry policy, stop conditions, cost events, and last successful test date.

See `docs/N8N_BACKUP_RESTORE.md`.
