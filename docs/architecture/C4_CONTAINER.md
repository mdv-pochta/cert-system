# C4 Level 2: Container Diagram

```
┌────────────────────────────────────────────────────────────────┐
│ Kubernetes Cluster                                             │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────┐                              │
│  │ In-Cluster Issuer Controller │                              │
│  │ - CRD management             │                              │
│  │ - Reconciliation loop        │                              │
│  │ - Secret management          │                              │
│  └──────────────┬───────────────┘                              │
│                 │ (gRPC)                                       │
│                 │                                              │
└─────────────────┼──────────────────────────────────────────────┘
                  │
      ┌───────────▼────────────┐
      │ External Agent (Linux) │
      │ ┌────────────────────┐ │
      │ │ gRPC Server        │ │
      │ ├────────────────────┤ │
      │ │ Worker Pool        │ │
      │ │ - Certbot (3-5)    │ │
      │ ├────────────────────┤ │
      │ │ Queue (Priority)   │ │
      │ ├────────────────────┤ │
      │ │ DNS Provider       │ │
      │ │ - Cloudflare       │ │
      │ │ - Route53          │ │
      │ └────────────────────┘ │
      │         │              │
      │         ▼              │
      │  ┌─────────────┐       │
      │  │ PostgreSQL  │       │
      │  │ - certs     │       │
      │  │ - queue     │       │
      │  │ - policies  │       │
      │  └─────────────┘       │
      └────────────────────────┘
```

## Containers

1. **In-Cluster Issuer** (K8s Deployment)
2. **External Agent** (Linux VM)
3. **PostgreSQL** (Shared database)
4. **Let's Encrypt** (External ACME)
5. **DNS Providers** (External APIs)
