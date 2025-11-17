# C4 Level 1: System Context

## Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    External Systems                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐      ┌──────────────┐  ┌──────────────┐   │
│  │  Kubernetes  │      │ Let's Encrypt│  │ DNS Provider │   │
│  │  Clusters    │      │   (ACME)     │  │(CF, Route53) │   │
│  │   (10x)      │      │              │  │              │   │
│  └──────┬───────┘      └──────┬───────┘  └──────┬───────┘   │
│         │                     │                 │           │
│         └─────────────────────┼─────────────────┘           │
│                               │                             │
│                    ┌──────────▼───────────┐                 │
│                    │ Certificate System   │                 │
│                    │  (gRPC + PostgreSQL) │                 │
│                    └──────────────────────┘                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘

## Components

1. **Kubernetes Clusters** - 10 k8s clusters with In-Cluster Issuer
2. **Certificate System** - External Agent + In-Cluster Controller
3. **Let's Encrypt** - ACME server for certificate issuance
4. **DNS Providers** - Cloudflare, AWS Route53 for DNS-01 challenge
```

## Key Interactions

- K8s → System: Certificate CRD requests (gRPC)
- System → LE: ACME certificate requests
- System → DNS: DNS record creation/deletion for challenge
- System → K8s: Certificate delivery via Kubernetes Secrets
