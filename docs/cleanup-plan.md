# Cleanup Report

## Completed workflow cleanup

- Archived `98 - Database Schema Audit`.
- Archived one-time cleanup workflows `97A`, `97B`, and `97C`.
- `Chat with the news` remains because it is not exposed to MCP; archive it manually from the n8n workflow card.

## Completed database cleanup

### Before

```text
28 Ocean Bridge tables
```

### Removed

- `ocean_bridge_campaign_send_controls`
- `ocean_bridge_email_verification_queue`
- `ocean_bridge_expo_ingestions`
- `ocean_bridge_scrapegraph_results`
- `ocean_bridge_nvidia_pilot_queue`
- `ocean_bridge_nvidia_pilot_results`
- `ocean_bridge_nvidia_pilot_runs`

### Preserved

- Verification state on `ocean_bridge_contacts`.
- Send controls on `ocean_bridge_campaigns`.
- ScrapeGraph request and result state on `ocean_bridge_scrapegraph_queue`.
- NVIDIA run, queue, and result history inside `ocean_bridge_cost_events.metadata`.
- `ocean_bridge_nvidia_reconciliation_summary` rebuilt as a view over archived cost events.

### After

```text
21 Ocean Bridge tables
```

## Why 17 core workflows remain

The workflows are separate because they represent different risk and business boundaries:

- Discovery can run without paid enrichment.
- Paid providers require explicit owner approval.
- Drafting is separate from sending.
- Buyer RFQs are separate from supplier offers.
- Deal and commission tracking must not be coupled to lead collection.

This modular structure is safer and easier to test. The clutter came from maintenance and experiment workflows, which have now been archived.
