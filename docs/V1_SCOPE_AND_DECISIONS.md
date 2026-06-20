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
