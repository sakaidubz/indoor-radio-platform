# Indoor Radio Platform (Rails Monolith)

Initial Rails scaffold for migrating from Go + Vue to a Rails monolith. HTML views use Slim; jQuery is included via CDN.

## Requirements
- Ruby 3.2+
- PostgreSQL 15+
- Bundler (`gem install bundler`)

## Setup
```bash
cd rails_app
bundle install
bin/rails db:create db:migrate
bin/rails server
```

Environment variables follow the root `.env` (DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME). Use `../scripts/setup-rails-postgres.sh` to prepare a local Postgres and `.env`.

Health check: `GET /health` returns `{ "status": "healthy" }`.
UI routes: `/dashboard`, `/artists`, `/episodes`.
