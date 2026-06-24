# V1 Scope and Business Decisions

## Purpose

V1 is an n8n-first autonomous buyer-acquisition engine for Ocean Bridge Trading.

The immediate goal is not supplier matching, quotation automation, or a full CRM. The immediate goal is to prove that one campaign input can automatically produce low-cost, contactable Chinese seafood buyer leads and outreach drafts, then monitor replies and surface quotation requests.

## Target Buyers

Any legitimate commercial buyer in China who can import, purchase, distribute, process, wholesale, or resell seafood supplied from Oman may be a target.

This includes importers, processors, distributors, wholesalers, trading companies, cold-storage businesses, food-service suppliers, regional seafood traders, phone-only or WeChat-first businesses, and companies with weak or no website presence.

A weak digital footprint does not make a company unqualified.

Reject only when the record is clearly unrelated to seafood, consumer-only, invalid, duplicated, fraudulent, suspicious, or unable to purchase commercially.

## Product Scope

Long-term scope:

> All seafood legally exportable from Oman and commercially relevant to China.

V1 uses active seasonal products configured per campaign.

Future structure:

- permanent product catalogue
- seasonal availability calendar
- active campaign products

The company profile may later include the full annual catalogue, while each outreach campaign emphasizes currently available products.

## Commercial Conditions

- minimum commercial quantity starts from one container
- no minimum company size
- no minimum revenue threshold
- no strict website requirement
- no minimum commission threshold for V1
- no strict decision-maker-name requirement

## Scoring Philosophy

Use separate dimensions:

1. Buyer likelihood
2. Product fit
3. Reachability
4. Beginner accessibility
5. Data confidence

Lead queues:

- Quick Win
- Strategic
- Dark Market
- Low Priority
- Rejected

Scoring routes leads; it should not automatically remove phone-only or low-digital-presence companies.

### Expo-first confidence rules

Official seafood expo exhibitor lists from the most recent five years are the first sourcing priority.

- official organizer list within 0–2 years: strongest source-confidence signal
- official organizer list within 3–5 years: strong source-confidence signal
- repeated exhibitor across years: additional confidence
- exhibitor product/category match: additional product-fit evidence
- data older than five years: discovery evidence only and must be refreshed

Expo evidence increases data confidence. It does not automatically prove current buyer intent. Final qualification still requires evidence that the company imports, buys, processes, distributes, wholesales, trades, stores, or resells seafood.

## V1 Identity and Deduplication

Keep company deduplication simple:

1. normalized domain when available
2. otherwise normalized company name plus country
3. email domain as supporting evidence when the website domain is missing

Do not add legal-entity, branch, or location identity models in V1.

A company may have many contacts. Different employees or departments at the same company remain separate contacts. Deduplicate contacts by normalized email first, then normalized phone or WeChat within the same company.

## Cost and Model Policy

The reported $100 spend for 53 raw company leads equals about $1.89 per raw lead and fails V1 economics, especially because employee enrichment was not completed.

No paid-model batch should run until provider-level usage is logged and a hard budget gate is active.

V1 cost targets:

- raw company candidate: at or below $0.10
- contactable company: at or below $0.30
- qualified contact: at or below $0.50

Controlled tests:

- maximum $5 per test run
- 10–20 companies per test
- stop automatically when the campaign or execution budget is reached

Model order:

1. deterministic code, SQL, regex, cache, and public structured data
2. NVIDIA-hosted model for bounded extraction or classification
3. local model after the workflow is stable
4. premium paid model only as an approved fallback

AI models must not be the primary company-discovery engine. They may generate search plans, classify ambiguous evidence, translate difficult text, or summarize sources after cheaper methods fail.

## V1 Automation Boundary

### V1 includes

- campaign input
- ICP and query generation
- company discovery
- normalization
- deduplication
- crawling
- evidence extraction
- classification
- contact discovery
- email verification
- multidimensional scoring
- personalized cold-email drafting
- controlled sending
- follow-ups
- reply monitoring
- quotation-request detection
- notification to the user

### V1 ends when a buyer asks for a quotation

At that point:

1. the system extracts the buyer request
2. the user sends it to the Oman partner
3. the Oman partner provides current price and availability
4. the user continues manually for pricing, negotiation, documents, commission protection, and shipment

Supplier matching and quotation automation belong to later versions.