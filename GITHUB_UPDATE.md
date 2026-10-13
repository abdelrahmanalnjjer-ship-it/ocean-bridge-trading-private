# GitHub Update — 2026-06-23

This update documents the deployed Ocean Bridge n8n system and its current PostgreSQL schema.

## Added

- `docs/workflows-database-schema.md`
- `docs/current-system-status.md`
- `database/current_schema.sql`
- `workflows/n8n/README.md`

## Current implementation covered

- Workflow 00: Seafood Product Intelligence Sync
- Workflow 01: Campaign & ICP Builder
- Workflow 02: Search and Company Collection
- 40 deployed nodes
- 10 active workflow-owned PostgreSQL tables
- 52 saved company candidates and 117 source records

## Not included

The package does not include fresh raw n8n JSON exports because the current connector exposes workflow structure but not a downloadable export action. Export each active workflow from n8n and place the JSON files under `workflows/n8n/` in a follow-up commit.
