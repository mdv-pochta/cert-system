-- Issuers table
CREATE TABLE issuers (
    id UUID PRIMARY KEY,
    cluster_name VARCHAR(255) NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    is_active BOOLEAN DEFAULT false,
    client_certificate BYTEA NOT NULL,
    client_key_encrypted BYTEA NOT NULL,
    ca_certificate BYTEA,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Domain Policies
CREATE TABLE domain_policies (
    id UUID PRIMARY KEY,
    issuer_id UUID NOT NULL REFERENCES issuers(id) ON DELETE CASCADE,
    domain_pattern VARCHAR(255) NOT NULL,
    pattern_type VARCHAR(20) NOT NULL,
    action VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(issuer_id, domain_pattern)
);
CREATE INDEX idx_domain_policies_issuer ON domain_policies(issuer_id);

-- Rate Limit Tracking
CREATE TABLE rate_limit_tracking (
    id UUID PRIMARY KEY,
    domain VARCHAR(255) NOT NULL,
    week_start_date DATE NOT NULL,
    total_available INT DEFAULT 50,
    used_for_renewal INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(domain, week_start_date)
);
CREATE INDEX idx_rate_limit_domain_week ON rate_limit_tracking(domain, week_start_date);

-- Certificate Requests Queue
CREATE TABLE certificate_requests (
    id UUID PRIMARY KEY,
    issuer_id UUID NOT NULL REFERENCES issuers(id),
    domain VARCHAR(255) NOT NULL,
    dns_names TEXT,
    duration_days INT DEFAULT 90,
    request_type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    priority INT DEFAULT 0,
    queue_position INT,
    error_message TEXT,
    retry_count INT DEFAULT 0,
    max_retries INT DEFAULT 5,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    processed_at TIMESTAMP
);
CREATE INDEX idx_requests_issuer_status ON certificate_requests(issuer_id, status);
CREATE INDEX idx_requests_priority_status ON certificate_requests(priority DESC, status, created_at);
CREATE INDEX idx_requests_domain ON certificate_requests(domain);

-- Certificates Storage
CREATE TABLE certificates (
    id UUID PRIMARY KEY,
    request_id UUID REFERENCES certificate_requests(id),
    issuer_id UUID NOT NULL REFERENCES issuers(id),
    domain VARCHAR(255) NOT NULL,
    certificate_pem TEXT NOT NULL,
    key_pem_encrypted BYTEA NOT NULL,
    ca_pem TEXT,
    serial_number VARCHAR(255),
    cn VARCHAR(255),
    san TEXT,
    issuer_name VARCHAR(255),
    not_before TIMESTAMP NOT NULL,
    not_after TIMESTAMP NOT NULL,
    renewal_scheduled_at TIMESTAMP,
    is_renewed BOOLEAN DEFAULT false,
    is_deleted BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX idx_certificates_domain_issuer ON certificates(domain, issuer_id);
CREATE INDEX idx_certificates_not_after ON certificates(not_after);
CREATE INDEX idx_certificates_renewal ON certificates(not_after) WHERE renewal_scheduled_at IS NULL;

-- Operations Log
CREATE TABLE operations_log (
    id UUID PRIMARY KEY,
    issuer_id UUID REFERENCES issuers(id),
    operation_type VARCHAR(50) NOT NULL,
    domain VARCHAR(255),
    status VARCHAR(20),
    message TEXT,
    error TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX idx_ops_log_issuer_timestamp ON operations_log(issuer_id, created_at DESC);
