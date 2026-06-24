BEGIN;

-- Immutable provider-level usage ledger. One paid or free provider request = one row.
CREATE TABLE IF NOT EXISTS ocean_bridge_api_cost_events (
    id BIGSERIAL PRIMARY KEY,
    campaign_key TEXT,
    workflow_name TEXT NOT NULL,
    n8n_execution_id TEXT,
    provider TEXT NOT NULL,
    service TEXT NOT NULL,
    model TEXT,
    operation TEXT NOT NULL,
    provider_request_id TEXT,

    input_tokens BIGINT NOT NULL DEFAULT 0 CHECK (input_tokens >= 0),
    cached_input_tokens BIGINT NOT NULL DEFAULT 0 CHECK (cached_input_tokens >= 0),
    output_tokens BIGINT NOT NULL DEFAULT 0 CHECK (output_tokens >= 0),
    quantity NUMERIC(18,6) CHECK (quantity IS NULL OR quantity >= 0),
    unit_type TEXT,

    provider_reported_cost_usd NUMERIC(14,6)
        CHECK (provider_reported_cost_usd IS NULL OR provider_reported_cost_usd >= 0),
    calculated_cost_usd NUMERIC(14,6)
        CHECK (calculated_cost_usd IS NULL OR calculated_cost_usd >= 0),
    final_cost_usd NUMERIC(14,6) GENERATED ALWAYS AS (
        COALESCE(provider_reported_cost_usd, calculated_cost_usd, 0)
    ) STORED,

    cost_status TEXT NOT NULL DEFAULT 'unpriced'
        CHECK (cost_status IN ('provider_reported', 'calculated', 'estimated', 'unpriced', 'free', 'failed')),
    request_status TEXT NOT NULL DEFAULT 'succeeded'
        CHECK (request_status IN ('succeeded', 'failed', 'retried', 'cancelled')),
    error_category TEXT,
    error_message TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_ob_cost_provider_request
    ON ocean_bridge_api_cost_events (provider, provider_request_id)
    WHERE provider_request_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_ob_cost_campaign_created
    ON ocean_bridge_api_cost_events (campaign_key, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_ob_cost_execution
    ON ocean_bridge_api_cost_events (n8n_execution_id)
    WHERE n8n_execution_id IS NOT NULL;

-- Versioned pricing reference used only when the provider does not return a final cost.
CREATE TABLE IF NOT EXISTS ocean_bridge_provider_pricing (
    id BIGSERIAL PRIMARY KEY,
    provider TEXT NOT NULL,
    service TEXT NOT NULL,
    model TEXT NOT NULL DEFAULT '',
    unit_type TEXT NOT NULL,
    cost_per_unit_usd NUMERIC(18,10) NOT NULL CHECK (cost_per_unit_usd >= 0),
    effective_from TIMESTAMPTZ NOT NULL,
    effective_to TIMESTAMPTZ,
    source_note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (effective_to IS NULL OR effective_to > effective_from),
    UNIQUE (provider, service, model, unit_type, effective_from)
);

-- Campaign and test-run spending rules.
CREATE TABLE IF NOT EXISTS ocean_bridge_campaign_cost_limits (
    campaign_key TEXT PRIMARY KEY,
    max_campaign_cost_usd NUMERIC(12,4) NOT NULL DEFAULT 50.00
        CHECK (max_campaign_cost_usd >= 0),
    max_test_run_cost_usd NUMERIC(12,4) NOT NULL DEFAULT 5.00
        CHECK (max_test_run_cost_usd >= 0),
    max_cost_per_raw_company_usd NUMERIC(12,4) NOT NULL DEFAULT 0.10
        CHECK (max_cost_per_raw_company_usd >= 0),
    max_cost_per_contactable_company_usd NUMERIC(12,4) NOT NULL DEFAULT 0.30
        CHECK (max_cost_per_contactable_company_usd >= 0),
    max_cost_per_qualified_contact_usd NUMERIC(12,4) NOT NULL DEFAULT 0.50
        CHECK (max_cost_per_qualified_contact_usd >= 0),
    hard_stop_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE VIEW ocean_bridge_campaign_cost_summary AS
SELECT
    campaign_key,
    COUNT(*) AS provider_request_count,
    COALESCE(SUM(final_cost_usd), 0)::NUMERIC(14,6) AS actual_cost_usd,
    COALESCE(SUM(input_tokens), 0) AS input_tokens,
    COALESCE(SUM(cached_input_tokens), 0) AS cached_input_tokens,
    COALESCE(SUM(output_tokens), 0) AS output_tokens,
    COUNT(*) FILTER (WHERE request_status = 'failed') AS failed_request_count,
    MAX(created_at) AS last_cost_event_at
FROM ocean_bridge_api_cost_events
GROUP BY campaign_key;

-- Call this before every paid provider request.
CREATE OR REPLACE FUNCTION ocean_bridge_can_spend(
    p_campaign_key TEXT,
    p_estimated_next_cost_usd NUMERIC
)
RETURNS TABLE (
    allowed BOOLEAN,
    actual_cost_usd NUMERIC,
    max_campaign_cost_usd NUMERIC,
    remaining_budget_usd NUMERIC
)
LANGUAGE SQL
STABLE
AS $$
    WITH limits AS (
        SELECT
            max_campaign_cost_usd,
            hard_stop_enabled
        FROM ocean_bridge_campaign_cost_limits
        WHERE campaign_key = p_campaign_key
    ),
    spend AS (
        SELECT COALESCE(SUM(final_cost_usd), 0)::NUMERIC AS actual_cost_usd
        FROM ocean_bridge_api_cost_events
        WHERE campaign_key = p_campaign_key
    )
    SELECT
        CASE
            WHEN limits.max_campaign_cost_usd IS NULL THEN FALSE
            WHEN limits.hard_stop_enabled IS FALSE THEN TRUE
            ELSE spend.actual_cost_usd + GREATEST(COALESCE(p_estimated_next_cost_usd, 0), 0)
                 <= limits.max_campaign_cost_usd
        END AS allowed,
        spend.actual_cost_usd,
        limits.max_campaign_cost_usd,
        GREATEST(limits.max_campaign_cost_usd - spend.actual_cost_usd, 0) AS remaining_budget_usd
    FROM spend
    LEFT JOIN limits ON TRUE;
$$;

COMMENT ON TABLE ocean_bridge_api_cost_events IS
'Immutable ledger for every provider request. Provider-reported cost is preferred; calculated cost is fallback only.';

COMMENT ON FUNCTION ocean_bridge_can_spend(TEXT, NUMERIC) IS
'Budget gate to call before every paid provider request. Missing campaign limits fail closed.';

COMMIT;
