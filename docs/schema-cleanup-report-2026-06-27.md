# Schema Cleanup Report — 2026-06-27

## Result

```text
Before: 28 tables
After:  21 tables
Removed: 7 tables
```

## Verified migration

- Verification queue rows migrated to contacts.
- Campaign send controls migrated to campaigns.
- Expo tracking replaced by shared collection-run data.
- ScrapeGraph queue now stores result payload, result status, and processed timestamp.
- NVIDIA history archived: 7 runs, 32 queue records, 13 result records.

## Removed tables

1. ocean_bridge_campaign_send_controls
2. ocean_bridge_email_verification_queue
3. ocean_bridge_expo_ingestions
4. ocean_bridge_scrapegraph_results
5. ocean_bridge_nvidia_pilot_queue
6. ocean_bridge_nvidia_pilot_results
7. ocean_bridge_nvidia_pilot_runs

## Preserved compatibility

`ocean_bridge_nvidia_reconciliation_summary` now reads from archived cost events, so historical reconciliation reporting remains available without the pilot tables.
