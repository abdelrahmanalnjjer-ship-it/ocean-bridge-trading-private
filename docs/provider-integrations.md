# Provider Integration Map

## Credential mapping

| Credential | Provider | Intended stage |
|---|---|---|
| Query Auth account 3 | Apollo | Approved contact enrichment |
| Query Auth account 2 | MillionVerifier | Approved email verification |
| Query Auth account | ScrapeGraphAI | Approved fallback extraction |

## Required control flow

```text
Public website evidence
→ ScrapeGraphAI only for approved high-value no-email companies
→ Apollo only after ScrapeGraph fails and owner approves cost
→ MillionVerifier only for approved relevant, non-disposable emails
→ Sending only after verified_valid + owner-approved draft + campaign enabled
```

## Current status

- Credential mapping confirmed.
- API node configurations validated.
- No paid provider worker is active.
- No provider API call was executed in the latest integration phase.
