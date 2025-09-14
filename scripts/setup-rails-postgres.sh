#!/usr/bin/env bash
set -euo pipefail

echo "📦 Rails + PostgreSQL setup"

if ! command -v psql >/dev/null 2>&1; then
  echo "❌ PostgreSQL (psql) not found. Install Postgres first." >&2
  exit 1
fi

DB_NAME=${DB_NAME:-indoor_radio_db}
DB_USER=${DB_USER:-indoor_radio}
DB_PASSWORD=${DB_PASSWORD:-indoor_radio_password}
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}

echo "→ Ensuring role and database exist ($DB_USER / $DB_NAME)"
psql postgres <<SQL
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$DB_USER') THEN
    CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
  END IF;
END$$;

SELECT 'CREATE DATABASE $DB_NAME OWNER $DB_USER'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$DB_NAME')\gexec

GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
ALTER USER $DB_USER CREATEDB;
\q
SQL

echo "→ Preparing .env if missing"
if [ ! -f .env ]; then
  cat > .env <<ENV
ENVIRONMENT=development
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_NAME=$DB_NAME
DB_SSL_MODE=disable
JWT_SECRET=change_me_for_production
PORT=3000
ENV
  echo "✓ .env created"
else
  echo "⚠️  .env already exists, skipping"
fi

if [ -x bin/rails ]; then
  echo "→ Rails database tasks (create/migrate)"
  echo "   From repo root: bundle install && bin/rails db:create db:migrate"
else
  echo "⚠️  Rails executable (bin/rails) not found; skipping Rails tasks"
fi

echo "🎉 Done"
