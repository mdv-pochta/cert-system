# ADR-003: Rate Limiting Strategy (75% Rule)

## Status
ACCEPTED

## Context
Let's Encrypt limit: 50 certs/domain/week. Need to handle renewals + new requests.

## Decision
75% rule with priority queue:
- Renewals: Priority, max 50 (all available)
- New certs: Max 75% of limit (37 certs/week)
- Parallel: Max 50% to LE simultaneously (25 requests)
- Exceeding requests: Queue for next week

## Algorithm
```
if request.isRenewal:
  allow if (total_used < 50)
else:
  allow if (new_available > 0)

new_available = (50 * 0.75) - (renewals - (renewals * 0.75))
```

## Consequences
- Guarantees renewals processed
- Balances new certificate requests
- Respects LE rate limits
