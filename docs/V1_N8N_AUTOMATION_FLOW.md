# V1 n8n Automation Flow

## Campaign Input

```json
{
  "campaign_name": "China Seasonal Seafood Campaign",
  "country": "China",
  "active_products": ["horse mackerel", "sardines", "shrimp"],
  "target_leads": 100,
  "outreach_language": "bilingual",
  "maximum_cost_per_usable_lead": 0.50,
  "automatic_sending": false
}
```

## Main Workflow

```text
Campaign Form/Webhook
→ Create Campaign in Neon
→ Generate English and Chinese Queries
→ Collect Candidate Companies
→ Normalize with Code Node
→ Deduplicate in Neon
→ Cheap Rule-Based Filter
→ Crawl Public Sources
→ Extract Evidence as JSON
→ Discover Contacts
→ Verify Email
→ Calculate Multi-Dimensional Scores
→ Generate Personalized Email
→ Send or Save Draft
→ Schedule Follow-Ups
→ Monitor Replies
→ Detect RFQ / Quotation Request
→ Notify User
```

## Cost-Control Waterfall

```text
1. Existing Neon data
2. Source-page contact details
3. Official company website
4. Public search result
5. Public business directory
6. Apify
7. Apollo
8. Prospeo
9. Email verifier
```

Stop as soon as acceptable contact data exists.

## Code-First Rules

Use code, SQL, JSON, and regex before paid model calls.

- normalize source records into one JSON structure
- extract domains and emails deterministically
- deduplicate by normalized name, country, city, domain, and source id
- run cheap English/Chinese seafood keyword filters
- extract emails, phones, URLs, WeChat labels, and contact-page links with regex
- calculate final scores with deterministic rules
- check cost and existing data before every paid provider call

## Token Savings

- one model call per company, not one call per field
- strict JSON output
- batch processing
- cache results in Neon
- hash source content and skip unchanged pages
- small model for easy classification
- large model only for difficult cases
- rules before models
- Apollo only after qualification
