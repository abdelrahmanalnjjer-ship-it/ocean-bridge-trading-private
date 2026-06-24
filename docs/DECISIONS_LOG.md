# Decisions Log

## 2026-06-20

### Buyer scope
Any legitimate Chinese commercial seafood buyer capable of importing or buying Oman seafood is in scope, including phone-only and low-digital-presence businesses.

### Product scope
All seafood legally exportable from Oman and commercially relevant to China. Campaigns focus on currently available seasonal products.

### Scoring
A single score is insufficient. Use buyer likelihood, product fit, reachability, beginner accessibility, and data confidence.

### V1 minimum quantity
One container.

### Automation principle
Automation is the main objective. Human involvement should be limited to exceptions and the quotation stage.

### V1 boundary
V1 ends when a buyer requests a quotation. Supplier pricing and commercial negotiation remain manual for now.

### Orchestration
n8n is mandatory for the first demonstrable V1. Python may replace or extend it later for lower cost and deeper integration.

### GitHub
A private repository must become the permanent project source of truth and recovery center.

## 2026-06-24

### Cost incident and new financial gate
A reported $100 of model credit produced only 53 company leads and no completed employee enrichment. That equals about $1.89 per raw lead and is unacceptable for V1. Historical spend cannot be reconstructed from Neon because provider-level token and request usage was not logged.

No new paid-model batch may run until every paid request writes a cost event and the campaign has a hard spending limit. Initial controlled tests are capped at $5 and 10–20 companies.

Target unit economics:

- raw company candidate: at or below $0.10
- contactable company: at or below $0.30
- qualified contact: at or below $0.50

### Model strategy
Use the cheapest reliable layer first:

1. SQL, code, regex, cached data, and deterministic rules
2. NVIDIA-hosted models for bounded classification or extraction tasks
3. a local model after the workflow is stable enough to justify hosting and maintenance
4. a premium paid model only as an explicitly approved fallback

Model calls must not be the primary company-discovery mechanism. They may generate queries, classify ambiguous evidence, or summarize difficult multilingual content.

### Expo-first sourcing
Official seafood expo exhibitor data from the most recent five years becomes the first sourcing priority. Repeated participation and recent participation increase data confidence.

Expo participation proves industry relevance and company existence, but does not by itself prove that the company is currently buying the campaign product. Current website, contact, product, importer, distributor, processor, or purchasing evidence is still required for final qualification.

### V1 company deduplication
Keep company identity simple for V1:

1. normalized domain when available
2. otherwise normalized company name plus country
3. use the email domain as supporting evidence when the website domain is missing

Do not build legal-entity, branch, or location identity models in V1.

### Multiple contacts per company
A company may contain several valid buyer contacts. Keep one company record and allow many contacts under it. Deduplicate contacts by normalized email first, then normalized phone or WeChat within the company. Different employees at the same company must remain separate contacts.

### Scoring interpretation
Expo recency and official organizer data affect the data-confidence dimension. Buyer likelihood, product fit, and reachability remain separate dimensions so an exhibitor is not automatically treated as a qualified buyer.