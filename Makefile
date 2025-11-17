.PHONY: help setup test build clean fmt lint

help:
	@echo "cert-system - Certificate Issuance System for Kubernetes"
	@echo ""
	@echo "Available targets:"
	@echo "  setup              - Setup development environment"
	@echo "  test               - Run all tests"
	@echo "  build              - Build all components"
	@echo "  docker-build       - Build Docker images"
	@echo "  deploy-local       - Deploy to local kind cluster"
	@echo "  lint               - Run linters"
	@echo "  fmt                - Format code"
	@echo "  clean              - Clean build artifacts"

setup: ## Setup development environment
	docker-compose up -d postgres pgadmin
	kind create cluster --name cert-system-dev --config kind-cluster-config.yaml || true
	kubectl create namespace cert-system || true
	@echo "✅ Setup complete!"

test: ## Run all tests
	go test ./... -v -cover

build: ## Build all components
	cd in-cluster-issuer && go build -o bin/issuer ./cmd
	cd external-agent && go build -o bin/agent ./cmd

docker-build: ## Build Docker images
	docker build -t cert-system/in-cluster-issuer:latest ./in-cluster-issuer
	docker build -t cert-system/external-agent:latest ./external-agent

deploy-local: ## Deploy to local kind cluster
	helm install external-agent charts/external-agent -n cert-system || true
	helm install issuer charts/in-cluster-issuer -n cert-system || true

lint: ## Run linters
	golangci-lint run ./...

fmt: ## Format code
	go fmt ./...

clean: ## Clean build artifacts
	rm -rf bin/ dist/
	docker-compose down

.PHONY: help setup test build clean fmt lint docker-build deploy-local
