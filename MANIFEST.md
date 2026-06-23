# Backup Manifest

**Last updated:** 23 June 2026

## Included in this repository

- README
- `.gitignore`
- sanitized `.env.example`
- V1 scope and decisions
- V1 n8n automation flow documentation
- Workflow 01: `workflows/n8n/01-campaign-icp-builder.json`
- integration map
- n8n backup and restore guide
- disaster recovery guide
- current Neon pilot status
- decisions log
- project backup status
- current limitations

## Not Yet Fully Included

The complete historical Kimi Workspace repository is not present in the current GitHub backup.

Still missing unless separately recovered or rebuilt:

- remaining Python scripts
- remaining n8n workflow exports beyond Workflow 01
- complete SQL migrations
- complete seed data
- test suite
- campaign configuration files
- original local Git history
- negative-control outputs
- unpublished Kimi files

## Current Backup Classification

`Partial canonical backup — documentation plus Workflow 01`

The repository is usable as the current project center, but it is not yet a complete reproducible backup.

## Safety

This repository must remain private. Real credentials, `.env`, database passwords, API tokens, mailbox passwords, and n8n credential values must never be committed.
