# ADR-002: Active-Passive HA with PostgreSQL Lease

## Status
ACCEPTED

## Context
Требуется HA для External Agent с recovery time < 30 sec.

## Decision
Active-Passive модель с PostgreSQL lease-based leader election.

## Design
```
Primary (Active)
  ↓ heartbeat каждые 5 сек
PostgreSQL Lease table
  ↑ watch
Backup (Standby)
```

- Failover detection: 3 missed heartbeats = ~15 sec
- Failover confirmation: < 30 sec total
- All state in PostgreSQL (no data loss)

## Consequences
- RTO: < 1 hour
- RPO: < 1 hour
- No Vault needed (PostgreSQL as coordination)
