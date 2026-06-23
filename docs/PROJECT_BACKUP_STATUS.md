# Project Backup Status

**Last updated:** 23 June 2026

## Included

- updated README and repository audit date
- sanitized `.env.example`
- strengthened `.gitignore`
- business scope and V1 decisions
- current Neon audit status
- integration map
- n8n backup and restore guide
- disaster recovery guide
- current limitations
- Workflow 01: `workflows/n8n/01-campaign-icp-builder.json`
- available pilot files where uploaded

## Verified GitHub State

- The repository is private.
- `main` is the canonical branch.
- Workflow 01 is present as a credential-free draft.
- Automatic sending remains disabled.
- Full live n8n execution has not yet been proven.
- The previously referenced `kimi/v1-seafood-engine` ref is not available in the current repository.

## Still Required for a Complete Reproducible Backup

Recover, rebuild, or upload:

- remaining `scripts/`
- `tests/`
- remaining workflow exports beyond Workflow 01
- `database/migrations/`
- `database/seed.sql`
- `campaigns/`
- unpublished documentation
- original local Git history or a Git bundle
- negative-control outputs

## Next Recovery Priority

1. Connect Workflow 01 to Neon using credentials stored only inside n8n.
2. Prove a controlled execution from campaign input to database logging and outreach draft.
3. Commit the database migrations and seed templates without secrets.
4. Recover or rebuild the remaining workflows one at a time with tests.

This private repository is the canonical project center, but it remains incomplete until the missing implementation assets are added and tested.
