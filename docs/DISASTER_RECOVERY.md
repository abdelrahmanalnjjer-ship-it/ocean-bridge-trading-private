# Disaster Recovery

## Recovery Priority

1. GitHub private repository
2. Neon project or Neon branch/PITR
3. n8n workflow exports
4. provider credential inventory
5. sender mailbox configuration
6. domain and DNS records
7. pilot and production runbooks

## What GitHub Recovers

- source code
- SQL migrations
- workflow JSON
- tests
- documentation
- configuration templates
- sample data
- runbooks

## What GitHub Does Not Recover

- live credentials
- n8n encrypted credential values
- mailbox passwords
- provider tokens
- Neon password
- DNS settings
- provider billing settings

Maintain a separate password-manager inventory containing service name, account email, recovery method, n8n credential name, billing owner, and last tested date. Do not store secret values here.

## Minimum Recovery Drill

Quarterly:

- create a new test Neon branch
- restore schema
- import one n8n workflow
- recreate one credential
- execute test data
- verify database output
- confirm no email is sent
