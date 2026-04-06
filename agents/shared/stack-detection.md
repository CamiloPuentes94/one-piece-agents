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
- **Patrón moderno**: Minimal APIs con `app.MapGet()` + `TypedResults` (preferido para APIs nuevas)
- **Patrón clásico**: Controllers/, Services/, Models/, DTOs/ (para proyectos existentes)
- ORM: Entity Framework Core con Npgsql + NetTopologySuite para PostGIS
- Swagger: **NSwag** (recomendado) — `AddEndpointsApiExplorer()` + `AddOpenApiDocument()` + `UseOpenApi()` + `UseSwaggerUi()`
- Migrations: `dotnet ef migrations add`, `dotnet ef database update`
- Run: `dotnet run`, `dotnet watch`
- Test: `dotnet test` (xUnit) + `WebApplicationFactory<Program>` para integration tests

#### Go (1.25+)
- Structure: cmd/, internal/, pkg/, api/
- Router: `http.NewServeMux()` (stdlib), gin, fiber, chi
- HTTP: `&http.Server{Addr: ":8080", Handler: mux}` + early return en cada error
- Swagger: swaggo/swag with annotations
- Migrations: golang-migrate or goose
- Run: `go run .`
- Test: `go test ./...` con table-driven tests + `t.Parallel()`
- Security: `govulncheck ./...` para escaneo de CVEs

#### FastAPI
- Structure: app/, routers/, models/, schemas/
- ORM: SQLAlchemy + Alembic + GeoAlchemy2 (PostGIS)
- **Pydantic v2** obligatorio: `response_model` en cada endpoint para validación automática
- Swagger: Built-in at /docs (auto-generated from Pydantic models) — usar `tags`, `summary`, `description`, `responses`
- Migrations: `alembic revision --autogenerate`, `alembic upgrade head`
- Run: `uvicorn app.main:app --reload`
- Test: `pytest` + `TestClient(app)` (sin servidor real)
- Security: `pip audit` o `safety check` para CVEs

#### Django
- Structure: apps/, models.py, views.py, serializers.py, urls.py
- API: Django REST Framework — `ModelViewSet` para CRUD, `APIView` para endpoints complejos
- Routing: `DefaultRouter` para URLs automáticas + `@action` para endpoints custom
- Swagger: drf-spectacular con `@extend_schema`
- ORM: Django ORM + `django.contrib.gis` para PostGIS (GeoDjango)
- Migrations: `python manage.py makemigrations`, `python manage.py migrate`
- Run: `python manage.py runserver`
- Test: `python manage.py test` or `pytest` + `APITestCase`

## Frontend Detection

| Stack | Detection Signals |
|-------|-------------------|
| **React 19** | `package.json` with `"react": "^19"` or `"react": "19"`, no `next` dep |
| **Next.js** | `package.json` with `"next"` dependency, `next.config.*` file |
| **Astro** | `package.json` with `"astro"` dependency, `astro.config.*` file |
| **Nuxt 4** | `package.json` with `"nuxt"` dependency, `nuxt.config.*` file |
| **Angular 21** | `package.json` with `"@angular/core"` dependency, `angular.json` file |

### Stack-Specific Conventions

#### React 19
- Structure: src/components/, src/pages/, src/hooks/, src/services/
- **Hooks clave**: `useActionState` (formularios), `useOptimistic` (UI optimista), `use()` (Contexts condicionales + Promises)
- State: Zustand o Jotai (nunca Context para estado frecuente)
- Styling: **Tailwind CSS v4** (CSS-first config con `@import "tailwindcss"`)
- Build: Vite
- Run: `npm run dev`
- Test: Vitest + React Testing Library
- E2E: Playwright con Page Object Model

#### Next.js
- Structure: app/ (App Router), components/, lib/
- Rendering: **Server Components por defecto**, `"use client"` solo para interactividad
- **Server Actions** con `"use server"`: reemplazan API routes para mutaciones
- Route Handlers: `route.ts` en `app/api/` para endpoints REST
- Cache: `revalidatePath()` / `revalidateTag()` para invalidación
- Middleware: `middleware.ts` en raíz — solo para auth/redirects, no lógica de negocio
- Run: `npm run dev`
- Test: Jest con `nextJest()` + React Testing Library. Playwright para E2E

#### Astro
- Structure: src/pages/, src/components/, src/layouts/
- **Islands Architecture**: componentes de framework son HTML estático por defecto — `client:load`, `client:visible`, `client:idle` para interactividad
- **Multi-framework**: puede importar React, Svelte, Vue, Solid, Preact
- SSG por defecto, SSR con adaptadores
- Run: `npm run dev`
- Test: Vitest

#### Nuxt 4
- Estructura: `app/` (srcDir), `app/pages/`, `app/components/`, `app/composables/`, `app/layouts/`, `server/api/`
- Directorio `shared/` para código compartido Vue + Nitro
- Auto-imports: composables, components, utilities — sin `import` manual
- Data Fetching: `useFetch()`, `useAsyncData()` — NUNCA `$fetch` directo en componentes (doble fetch SSR)
- State: `useState()` composable para estado compartido
- Config: `nuxt.config.ts` con `defineNuxtConfig()`
- Run: `npx nuxi dev` o `npm run dev`
- Test: `@nuxt/test-utils` + Vitest + happy-dom

#### Angular 21
- Estructura: `src/app/` (componentes, servicios, guards), `angular.json` config
- Standalone por defecto: componentes sin NgModule — `imports` en `@Component`
- Signals: `signal()`, `computed()`, `effect()`, `linkedSignal()` — primitivo reactivo central
- Signal Forms (v21): `form()` + `FormField` — reemplaza ReactiveFormsModule
- Control flow nativo: `@if`, `@for`, `@switch` en templates
- Zoneless: `provideZonelessChangeDetection()` — sin Zone.js
- SSR: `@angular/ssr/node` con Express
- Run: `ng serve` o `npm start`
- Test: `ng test` (Jasmine/Karma), Vitest experimental
- CLI: `ng generate`, `ng build`, `ng serve`, `ng test`

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
6. **Stacks no soportados**: si se detecta Ruby, Java/Spring, Svelte, u otro stack no listado:
   - Luffy pregunta al usuario cómo proceder
   - Robin investiga el stack con Context7 (`resolve-library-id` → `query-docs`)
   - Los agentes dev adaptan sus prácticas generales al nuevo stack
   - Las reglas de verificación de Law, testing de Usopp y seguridad de Jinbe aplican independientemente del stack
