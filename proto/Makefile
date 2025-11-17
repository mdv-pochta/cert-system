.PHONY: generate

generate:
	cd cert_issuer/v1 && \
	protoc --go_out=. --go-grpc_out=. \
	  certificate_service.proto \
	  admin_service.proto
