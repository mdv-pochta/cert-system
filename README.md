# Certificate Issuance System for Kubernetes

Распределённая система выдачи SSL/TLS сертификатов для Kubernetes с использованием Let's Encrypt и DNS-01 challenge.

## Quick Start

```bash
# Setup environment
make setup

# Deploy to local cluster
make deploy-local

# View logs
kubectl -n cert-system logs -f deployment/external-agent

Documentation

    Architecture

    API

    Deployment

Development

bash
# Run tests
make test

# Format code
make fmt

# Run linters
make lint

License

MIT
