# Rails Monolith Migration Plan

This branch introduces an initial Rails 7 monolith scaffold to replace the current Go + Vue structure. We will migrate API, domain logic, and web UI into a single Rails app.

## Phases
- Scaffold Rails app with Postgres config and basic health/root endpoints.
- Migrate authentication (JWT → Rails sessions/Devise or JWT via rack middleware).
- Port domain models (User, Artist, Episode, SocialPost) and DB schema via Rails migrations.
- Recreate REST endpoints under Rails controllers and routes.
- Replace Vue UI with Rails views or mount a SPA under `app/javascript` (TBD).
- Remove legacy Go/Vue code once feature parity is reached.

## Local Development
- Ruby 3.2+ and PostgreSQL 15+
- In `rails_app/`: `bundle install` then `bin/rails server`.
- Uses existing `.env` DB variables (DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME).

## Notes
- Database names and credentials mirror current `.env` for a smooth switch.
- Incremental PRs are expected; this first PR adds the scaffold only.
