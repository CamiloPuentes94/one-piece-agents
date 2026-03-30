# Tech Stack Detection Rules — Shared Reference

## How Agents Detect the Project's Stack

Before implementing, dev agents MUST detect the project's tech stack by examining project files. Use these rules:

## Backend Detection

| Stack | Detection Signals | Priority |
|-------|-------------------|----------|
| **.NET 10** | `*.csproj`, `Program.cs`, `*.sln`, `appsettings.json`, `global.json` with SDK version | **Primary** |
| **Go** | `go.mod`, `go.sum`, `main.go`, `*.go` files | Secondary |
| **FastAPI** | `main.py` with `from fastapi`, `pyproject.toml` with `fastapi` dep, `requirements.txt` with `fastapi` | Secondary |
| **Django** | `manage.py`, `settings.py`, `urls.py`, `wsgi.py`, `requirements.txt` with `django` | Secondary |

### Stack-Specific Conventions

#### .NET 10 (Principal)
- Framework: ASP.NET Core 10
- Structure: Controllers/, Services/, Models/, DTOs/
- ORM: Entity Framework Core
- Swagger: Swashbuckle.AspNetCore or NSwag
- Migrations: `dotnet ef migrations add`, `dotnet ef database update`
- Run: `dotnet run`, `dotnet watch`
- Test: `dotnet test` (xUnit or NUnit)

#### Go
- Structure: cmd/, internal/, pkg/, api/
- Router: gin, fiber, chi, or net/http
- Swagger: swaggo/swag with annotations
- Migrations: golang-migrate or goose
- Run: `go run .`
- Test: `go test ./...`

#### FastAPI
- Structure: app/, routers/, models/, schemas/
- ORM: SQLAlchemy + Alembic
- Swagger: Built-in at /docs (auto-generated from Pydantic models)
- Migrations: `alembic revision --autogenerate`, `alembic upgrade head`
- Run: `uvicorn app.main:app --reload`
- Test: `pytest`

#### Django
- Structure: apps/, models.py, views.py, serializers.py, urls.py
- API: Django REST Framework
- Swagger: drf-spectacular
- Migrations: `python manage.py makemigrations`, `python manage.py migrate`
- Run: `python manage.py runserver`
- Test: `python manage.py test` or `pytest`

## Frontend Detection

| Stack | Detection Signals |
|-------|-------------------|
| **React 19** | `package.json` with `"react": "^19"` or `"react": "19"`, no `next` dep |
| **Next.js** | `package.json` with `"next"` dependency, `next.config.*` file |
| **Astro** | `package.json` with `"astro"` dependency, `astro.config.*` file |

### Stack-Specific Conventions

#### React 19
- Structure: src/components/, src/pages/, src/hooks/, src/services/
- State: React hooks, context, or Zustand/Jotai
- Build: Vite
- Run: `npm run dev`
- Test: Vitest + React Testing Library

#### Next.js
- Structure: app/ (App Router), components/, lib/
- Rendering: Server Components by default, `"use client"` for client
- API Routes: app/api/
- Run: `npm run dev`
- Test: Jest or Vitest + React Testing Library

#### Astro
- Structure: src/pages/, src/components/, src/layouts/
- Islands: Interactive components with `client:*` directives
- Run: `npm run dev`
- Test: Vitest

## Database (Always)

| Stack | Always |
|-------|--------|
| **PostgreSQL + PostGIS** | The ONLY permitted database. No SQLite, MySQL, MongoDB, or others. |

### Connection Detection
- `.env` or `.env.example` with `DATABASE_URL` containing `postgresql://` or `postgres://`
- `docker-compose.yml` with `postgis/postgis` or `postgres` image
- ORM config pointing to PostgreSQL

## Rules

1. ALWAYS detect stack before implementing — never assume
2. If multiple backend stacks coexist (monorepo), ask Luffy which to target
3. If NO stack is detected (new project), ask Luffy which stack to initialize
4. .NET 10 is the PRIMARY backend — use it when user has no preference
5. PostgreSQL+PostGIS is ALWAYS the database — no exceptions
