-- Runs on initial creation of the PostgreSQL data volume.
-- Application domain SQL schemas and migrations belong in search-service, not here.
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
