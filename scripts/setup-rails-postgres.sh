#!/usr/bin/env bash
set -euo pipefail

echo "Rails + PostgreSQL setup"

if ! command -v psql >/dev/null 2>&1; then
  echo "ERROR: PostgreSQL (psql) not found. Install Postgres first." >&2
  exit 1
fi

DB_NAME=${DB_NAME:-indoor_radio_db}
DB_USER=${DB_USER:-indoor_radio}
DB_PASSWORD=${DB_PASSWORD:-indoor_radio_password}
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}

# Create .env first so subsequent steps can rely on it
echo "Preparing .env"
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
  echo ".env already exists, skipping creation"
fi

echo "Ensuring role and database exist ($DB_USER / $DB_NAME)"
run_psql() {
  # Try via local postgres system user first (will prompt for sudo password if needed)
  if command -v sudo >/dev/null 2>&1; then
    if sudo -u postgres psql -v ON_ERROR_STOP=1 -c '\q' postgres >/dev/null 2>&1; then
      sudo -u postgres psql -v ON_ERROR_STOP=1 postgres "$@"
      return $?
    fi
  fi
  # Fallback: try TCP as postgres user (may require password configured)
  psql -v ON_ERROR_STOP=1 -U postgres -h 127.0.0.1 -p "$DB_PORT" postgres "$@"
}

set +e
run_psql <<SQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$DB_USER') THEN
    CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD' CREATEDB;
  ELSE
    -- Ensure password and CREATEDB
    EXECUTE format('ALTER USER %I WITH PASSWORD %L CREATEDB', '$DB_USER', '$DB_PASSWORD');
  END IF;
END\$\$;

SELECT 'CREATE DATABASE $DB_NAME OWNER $DB_USER'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$DB_NAME')\gexec

GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
\q
SQL
psql_status=$?
set -e

if [ $psql_status -ne 0 ]; then
  cat >&2 <<ERR
ERROR: Failed to connect as postgres to provision role/database.

Try manually:
  sudo -u postgres psql
Then run inside psql:
  CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD' CREATEDB;
  CREATE DATABASE $DB_NAME OWNER $DB_USER;
  GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
ERR
  exit 1
fi

if [ -x bin/rails ]; then
  echo "Rails database tasks (create/migrate)"
  echo "From repo root: bundle install && bin/rails db:create db:migrate"
else
  echo "Rails executable (bin/rails) not found; skipping Rails tasks"
fi

echo "Done"
