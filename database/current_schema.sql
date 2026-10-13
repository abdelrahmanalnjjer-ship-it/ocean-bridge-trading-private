-- Ocean Bridge Trading
-- Current PostgreSQL schema directly declared and used by n8n Workflows 00–02.
-- Generated from the deployed workflow DDL on 2026-06-23.

BEGIN;

CREATE TABLE IF NOT EXISTS ocean_bridge_product_intelligence (
  id BIGSERIAL PRIMARY KEY,
  product_key TEXT NOT NULL UNIQUE,
  hs_code TEXT,
  english_name TEXT NOT NULL,
  normalized_name TEXT NOT NULL,
  chinese_trade_name TEXT,
  product_family TEXT,
  market_segment TEXT,
  product_state TEXT,
  product_cut TEXT,
  search_aliases JSONB NOT NULL DEFAULT '[]'::jsonb,
  target_chinese_ports JSONB NOT NULL DEFAULT '[]'::jsonb,
  price_min_usd_per_mt NUMERIC(12,2),
  price_max_usd_per_mt NUMERIC(12,2),
  industrial_processing_hubs JSONB NOT NULL DEFAULT '[]'::jsonb,
  luxury_wholesale_markets JSONB NOT NULL DEFAULT '[]'::jsonb,
  gacc_compliance_risks JSONB NOT NULL DEFAULT '[]'::jsonb,
  data_status TEXT NOT NULL DEFAULT 'needs_verification',
  source_name TEXT,
  source_payload JSONB NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ocean_bridge_campaigns (
  id BIGSERIAL PRIMARY KEY,
  campaign_key TEXT NOT NULL UNIQUE,
  campaign_name TEXT NOT NULL,
  target_country TEXT NOT NULL,
  active_products JSONB NOT NULL DEFAULT '[]'::jsonb,
  target_leads INTEGER NOT NULL CHECK (target_leads > 0),
  max_cost_per_contactable_lead_usd NUMERIC(10,4) NOT NULL CHECK (max_cost_per_contactable_lead_usd >= 0),
  campaign_payload JSONB NOT NULL,
  icp_payload JSONB NOT NULL,
  safety_payload JSONB NOT NULL,
  status TEXT NOT NULL DEFAULT 'ready_for_collection',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ocean_bridge_search_plans (
  id BIGSERIAL PRIMARY KEY,
  campaign_key TEXT NOT NULL UNIQUE REFERENCES ocean_bridge_campaigns(campaign_key) ON DELETE CASCADE,
  query_count INTEGER NOT NULL DEFAULT 0,
  queries JSONB NOT NULL DEFAULT '[]'::jsonb,
  priority_cities JSONB NOT NULL DEFAULT '[]'::jsonb,
  source_order JSONB NOT NULL DEFAULT '[]'::jsonb,
  search_plan_payload JSONB NOT NULL,
  status TEXT NOT NULL DEFAULT 'ready',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ocean_bridge_campaign_products (
  id BIGSERIAL PRIMARY KEY,
  campaign_key TEXT NOT NULL REFERENCES ocean_bridge_campaigns(campaign_key) ON DELETE CASCADE,
  product_key TEXT NOT NULL REFERENCES ocean_bridge_product_intelligence(product_key),
  requested_product TEXT NOT NULL,
  match_score INTEGER NOT NULL DEFAULT 0,
  data_status TEXT NOT NULL DEFAULT 'needs_verification',
  selected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (campaign_key, requested_product)
);

CREATE TABLE IF NOT EXISTS ocean_bridge_collection_runs (
  id BIGSERIAL PRIMARY KEY,
  run_key TEXT NOT NULL UNIQUE,
  campaign_key TEXT NOT NULL REFERENCES ocean_bridge_campaigns(campaign_key) ON DELETE CASCADE,
  run_mode TEXT NOT NULL,
  live_collection BOOLEAN NOT NULL DEFAULT FALSE,
  pilot_limit INTEGER NOT NULL CHECK (pilot_limit BETWEEN 1 AND 100),
  query_limit INTEGER NOT NULL CHECK (query_limit BETWEEN 1 AND 30),
  results_per_query INTEGER NOT NULL CHECK (results_per_query BETWEEN 1 AND 10),
  status TEXT NOT NULL DEFAULT 'created',
  queries_total INTEGER NOT NULL DEFAULT 0,
  queries_processed INTEGER NOT NULL DEFAULT 0,
  candidates_found INTEGER NOT NULL DEFAULT 0,
  unique_companies INTEGER NOT NULL DEFAULT 0,
  provider_usage JSONB NOT NULL DEFAULT '{}'::jsonb,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ocean_bridge_search_jobs (
  id BIGSERIAL PRIMARY KEY,
  job_key TEXT NOT NULL UNIQUE,
  run_key TEXT NOT NULL REFERENCES ocean_bridge_collection_runs(run_key) ON DELETE CASCADE,
  campaign_key TEXT NOT NULL REFERENCES ocean_bridge_campaigns(campaign_key) ON DELETE CASCADE,
  query_text TEXT NOT NULL,
  query_position INTEGER NOT NULL,
  query_hash TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'queued',
  provider TEXT,
  result_count INTEGER NOT NULL DEFAULT 0,
  accepted_count INTEGER NOT NULL DEFAULT 0,
  cost_status TEXT NOT NULL DEFAULT 'unpriced',
  error_message TEXT,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (run_key, query_hash)
);

CREATE TABLE IF NOT EXISTS ocean_bridge_companies (
  id BIGSERIAL PRIMARY KEY,
  company_key TEXT NOT NULL UNIQUE,
  canonical_name TEXT NOT NULL,
  normalized_name TEXT NOT NULL,
  domain TEXT,
  website TEXT,
  country TEXT,
  city TEXT,
  company_type TEXT,
  relevance_score INTEGER NOT NULL DEFAULT 0,
  relevance_status TEXT NOT NULL DEFAULT 'candidate',
  evidence_summary TEXT,
  first_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ocean_bridge_company_sources (
  id BIGSERIAL PRIMARY KEY,
  company_id BIGINT NOT NULL REFERENCES ocean_bridge_companies(id) ON DELETE CASCADE,
  campaign_key TEXT NOT NULL REFERENCES ocean_bridge_campaigns(campaign_key) ON DELETE CASCADE,
  run_key TEXT NOT NULL REFERENCES ocean_bridge_collection_runs(run_key) ON DELETE CASCADE,
  query_text TEXT NOT NULL,
  source_url TEXT,
  source_title TEXT,
  source_snippet TEXT,
  source_provider TEXT,
  evidence TEXT,
  source_hash TEXT NOT NULL,
  collected_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (company_id, source_hash)
);

CREATE TABLE IF NOT EXISTS ocean_bridge_campaign_companies (
  campaign_key TEXT NOT NULL REFERENCES ocean_bridge_campaigns(campaign_key) ON DELETE CASCADE,
  company_id BIGINT NOT NULL REFERENCES ocean_bridge_companies(id) ON DELETE CASCADE,
  run_key TEXT NOT NULL REFERENCES ocean_bridge_collection_runs(run_key) ON DELETE CASCADE,
  initial_score INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'candidate',
  matched_products JSONB NOT NULL DEFAULT '[]'::jsonb,
  matched_query TEXT,
  first_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_seen_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (campaign_key, company_id)
);

CREATE TABLE IF NOT EXISTS ocean_bridge_collection_cost_events (
  id BIGSERIAL PRIMARY KEY,
  run_key TEXT NOT NULL REFERENCES ocean_bridge_collection_runs(run_key) ON DELETE CASCADE,
  provider TEXT NOT NULL,
  event_type TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  cost_status TEXT NOT NULL DEFAULT 'unpriced',
  estimated_cost_usd NUMERIC(12,4),
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ob_product_normalized_name ON ocean_bridge_product_intelligence(normalized_name);
CREATE INDEX IF NOT EXISTS idx_ob_product_family ON ocean_bridge_product_intelligence(product_family);
CREATE INDEX IF NOT EXISTS idx_ob_product_segment ON ocean_bridge_product_intelligence(market_segment);
CREATE INDEX IF NOT EXISTS idx_ob_product_status ON ocean_bridge_product_intelligence(data_status);
CREATE INDEX IF NOT EXISTS idx_ob_product_aliases_gin ON ocean_bridge_product_intelligence USING GIN(search_aliases);
CREATE INDEX IF NOT EXISTS idx_ob_product_ports_gin ON ocean_bridge_product_intelligence USING GIN(target_chinese_ports);
CREATE INDEX IF NOT EXISTS idx_ob_campaigns_status ON ocean_bridge_campaigns(status);
CREATE INDEX IF NOT EXISTS idx_ob_search_plans_status ON ocean_bridge_search_plans(status);
CREATE INDEX IF NOT EXISTS idx_ob_campaign_products_campaign ON ocean_bridge_campaign_products(campaign_key);
CREATE INDEX IF NOT EXISTS idx_ob_campaign_products_product ON ocean_bridge_campaign_products(product_key);
CREATE INDEX IF NOT EXISTS idx_ob_collection_runs_status ON ocean_bridge_collection_runs(status);
CREATE INDEX IF NOT EXISTS idx_ob_search_jobs_run_status ON ocean_bridge_search_jobs(run_key, status);
CREATE INDEX IF NOT EXISTS idx_ob_companies_domain ON ocean_bridge_companies(domain) WHERE domain IS NOT NULL AND domain <> '';
CREATE INDEX IF NOT EXISTS idx_ob_companies_relevance ON ocean_bridge_companies(relevance_status, relevance_score DESC);
CREATE INDEX IF NOT EXISTS idx_ob_company_sources_campaign ON ocean_bridge_company_sources(campaign_key);

COMMIT;
