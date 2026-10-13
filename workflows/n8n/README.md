# n8n Workflow Inventory

This directory tracks the deployed Ocean Bridge workflow set.

| Number | Workflow | n8n ID | Active |
|---|---|---|---:|
| 00 | Seafood Product Intelligence Sync | `tjyNVdli2GDekLOQ` | No |
| 01 | Ocean Bridge Campaign & ICP Builder | `OI6bDJTZ2iBX4Vvn` | Yes |
| 02 | Search and Company Collection | `sdH96TyffJ5nlFUl` | Yes |

Detailed node behavior, data contracts, and database effects are documented in:

- `docs/workflows-database-schema.md`
- `docs/current-system-status.md`

## Security rules

- No public database-writing webhook is enabled for Workflow 01 or Workflow 02.
- Workflow 00 remains inactive because its webhook has no authentication.
- Automatic outreach is disabled.
- Commercial commitments require human approval.

## Export policy

After each material n8n change, export the updated workflow JSON into this directory and commit it together with the related schema or documentation change.
