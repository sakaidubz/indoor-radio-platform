# Repository Guidelines

## Project Structure & Module Organization
- Backend Go code lives under `internal/` using Clean Architecture:
  - `internal/api/{handlers,middleware,routes}` for HTTP layer
  - `internal/domain/{entities,repositories,services}` for core logic
  - `internal/infrastructure/{database,external,storage}` for adapters
- Entry point: `cmd/server/main.go`
- Frontend: `web/` (Vue 3 + Vite + Tailwind)
- Scripts: `scripts/` (e.g., `setup-database.sh`)
- Docs and planning: `memory-bank/`

## Build, Test, and Development Commands
- Backend
  - `go mod tidy` — sync Go dependencies
  - `go run cmd/server/main.go` — start API server (reads `.env`)
  - `go test ./...` — run all Go tests
  - `go test -cover ./...` — run tests with coverage
- Database
  - `./scripts/setup-database.sh` — create local DB/user and generate `.env`
- Frontend (in `web/`)
  - `npm install` — install dependencies
  - `npm run dev` — start Vite dev server
  - `npm run build` / `npm run preview` — build/preview production
  - `npm run lint` / `npm run format` — lint and format frontend code

## Coding Style & Naming Conventions
- Go
  - Format with `go fmt ./...`; keep imports tidy.
  - Package names: short lowercase (no underscores). Exported types/functions use PascalCase; unexported use camelCase.
  - File naming: `snake_case.go`; group by feature (e.g., `auth_handler.go`).
  - Respect layering: domain is framework-agnostic; infra implements domain interfaces.
- Frontend
  - Use ESLint + Prettier via provided scripts.
  - Vue SFCs in `PascalCase.vue`; routes/components named consistently with file names.

## Testing Guidelines
- Go tests use the standard `testing` package; name files `*_test.go` and prefer table-driven tests.
- Add tests for services and handlers where feasible; focus on domain logic.
- Run `go test ./...` locally; include edge cases and error paths.

## Commit & Pull Request Guidelines
- Prefer Conventional Commits (`feat:`, `fix:`, `chore:`) with imperative mood and concise scope. Example: `feat(auth): add JWT middleware`.
- Reference issues when applicable (`Closes #123`).
- PRs include: clear description, rationale, test notes, screenshots for UI, and any config changes.
- Update relevant docs (README, `memory-bank/`) when behavior or decisions change.

## Security & Configuration
- Do not commit secrets. Use `.env` (see `.env.example`); the app reads env via `internal/config`.
- Keep local creds minimal privilege; never hardcode tokens or keys.
