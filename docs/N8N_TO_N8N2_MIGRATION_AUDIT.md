# n8n → n8n2 Migration Audit

**Audit date:** 24 June 2026  
**Project:** Ocean Bridge Trading

## Decision

Do **not** disconnect the original n8n instance yet.

The shared Neon data is safe and does not need to be moved between n8n instances, but the original n8n still contains workflow definitions, credentials/configuration references, and execution history that are not fully preserved in GitHub.

## Original n8n inventory

Original n8n project ID: `sI3cPBYW0WkNuFcO`

| Workflow | Original workflow ID | Status at last audit | Nodes |
|---|---|---:|---:|
| 00 — Seafood Product Intelligence Sync | `tjyNVdli2GDekLOQ` | inactive | 6 |
| 01 — Ocean Bridge Campaign & ICP Builder | `OI6bDJTZ2iBX4Vvn` | active, internal/manual | 15 |
| 02 — Search and Company Collection | `sdH96TyffJ5nlFUl` | active, internal/manual | 19 |

Total: 3 workflows and 40 nodes.

## Live Neon data confirmed during migration audit

These records already live in Neon and do not need to be copied from n8n to n8n2:

- 2 campaigns
- 13 collection runs
- 208 search jobs
- 142 companies
- 151 company source/evidence rows
- 162 collection cost events

The cost events are still unpriced. The new provider-level cost-ledger migration has been committed to GitHub but is not yet confirmed as applied to Neon.

## Critical findings

1. GitHub `main` confirms Workflow 01, but fresh raw JSON exports for all three deployed workflows are not confirmed in the repository.
2. The documentation-only PR for the deployed system remains open and explicitly states that raw exports were not included.
3. Workflow 02 executed multiple live research runs on 22 June 2026.
4. One run processed 28 queries, produced 247 raw candidates, and saved 52 unique companies.
5. Two later live runs processed 30 queries each but recorded the provider as `unknown` and returned no new candidates.
6. The database contains 162 cost events, all unpriced, including 60 provider events recorded as `unknown`.
7. Old n8n execution history may be the only available evidence for request counts, retries, node failures, and model responses related to the reported $100 credit consumption.

## Must move or record before disconnecting original n8n

### 1. Fresh workflow JSON exports

Export the latest version of all three workflows directly from the original n8n:

- `00-seafood-product-intelligence-sync.json`
- `01-campaign-icp-builder.json`
- `02-search-company-collection.json`

Store sanitized copies under `workflows/n8n/` in GitHub. Do not include credential secrets.

### 2. Credential inventory

Record credential **names and types** used by each node, then recreate them manually in n8n2:

- Neon/PostgreSQL credential
- old OpenAI or managed research credential
- replacement NVIDIA credential when added
- webhook/header-auth credential when Workflow 00 is secured
- any HTTP/API credential used by future source providers

Do not copy secrets into GitHub.

If both instances are self-hosted and a full credential database migration is attempted, preserve the original `N8N_ENCRYPTION_KEY`. Without the matching key, encrypted credentials cannot be decrypted. For a normal workspace-to-workspace migration, recreate credentials manually instead.

### 3. Workflow-to-workflow references

Imported workflows normally receive new IDs. Reconnect any Execute Workflow / sub-workflow references after import:

- Workflow 01 calling Workflow 02
- any workflow calling Workflow 01

Do not assume original IDs will work in n8n2.

### 4. Webhooks and external callers

Webhook URLs change when the instance changes.

- Workflow 00 webhook is currently inactive and unauthenticated; do not activate it in n8n2 until header authentication is configured.
- Workflow 01 and 02 are internal/manual at the last audit.
- Record any external caller, form, script, or test client that still uses an old n8n webhook URL.

### 5. Variables, project settings, and runtime configuration

Record and recreate:

- n8n variables used in expressions
- environment variables used by Code or HTTP nodes
- project/folder organization
- workflow tags
- timezone
- execution-data retention settings
- concurrency and timeout settings
- community nodes and their versions
- n8n version

### 6. Execution evidence for the $100 incident

Before disconnecting, preserve the executions for the live Workflow 02 runs from 22 June 2026, especially:

- `collect-20260622173337-kh8mv0`
- `collect-20260622174251-zop3nl`
- `collect-20260622175958-cpf04j`
- `collect-20260622183243-nj8tcy`

For each execution, record:

- n8n execution ID
- start/end time
- number of OpenAI/model node calls
- retry count
- input/output usage returned by the provider, if shown
- errors or parse failures
- model name
- response/request IDs, if available

Do not delete the original instance until this evidence is saved or the provider dashboard has already explained the full spend.

### 7. Schedules and activation state

Import all workflows into n8n2 as **inactive**.

Keep paid research and outreach disabled until:

- the cost-ledger migration is applied
- hard budget checks run before each paid call
- cost events are written after each paid call
- a maximum $5 controlled test reconciles with the provider dashboard

## Items that do not need to move

- Neon tables and data: both instances should point to the same Neon project.
- GitHub documentation and migrations: already stored in the private repository.
- Old webhook URLs: they should be replaced, not migrated.
- Old exhausted managed OpenAI credits: do not reuse them.

## n8n2 acceptance test before old n8n disconnection

The original n8n can be disconnected only after all checks pass:

1. All three workflows are visible in n8n2.
2. Node counts and connection paths match the exported originals.
3. Every PostgreSQL node uses the correct Neon credential.
4. Workflow 01 can create or update a test campaign without paid model calls.
5. Workflow 02 dry-run completes without a paid call.
6. Workflow-to-workflow references work with the new IDs.
7. Workflow 00 remains inactive until authenticated.
8. No schedule, webhook, or paid node is accidentally active.
9. Execution history needed for the $100 audit has been preserved.
10. Fresh sanitized exports from n8n2 are committed to GitHub.

## Disconnect gate

**Current result: NOT SAFE TO DISCONNECT ORIGINAL n8n.**

Primary blockers:

- n8n2 contents cannot yet be directly verified from the available connector
- fresh exports of Workflows 00 and 02 are not confirmed in GitHub
- credential recreation in n8n2 is not confirmed
- workflow-to-workflow ID remapping is not confirmed
- execution history for the $100 incident is not preserved
- cost controls are not live in Neon
