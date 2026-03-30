## 1. Project Setup & Shared Infrastructure

- [x] 1.1 Initialize project structure: `agents/`, `agents/shared/`, `logs/`, `config/`
- [x] 1.2 Create shared logging module (`agents/shared/logging.md`) with agent identity prefixes, console + file output, timestamp format
- [x] 1.3 Create shared OpenSpec flow reference (`agents/shared/openspec-flow.md`) documenting the explore→propose→apply→verify→archive lifecycle
- [x] 1.4 Create shared tech stack detection rules (`agents/shared/stack-detection.md`) for identifying .NET 10, Go, FastAPI, Django, React 19, Next.js, Astro from project files
- [x] 1.5 Create agent configuration schema (`agents/shared/agent-schema.md`) defining the standard structure for AGENT.md files (role, personality, tools, rules, interactions)

## 2. Orchestrator — Luffy

- [x] 2.1 Create `agents/luffy/AGENT.md` with system prompt: role as orchestrator, personality (Shishishi, Yosh, nakama), rule that Luffy NEVER writes code
- [x] 2.2 Implement explore phase logic in Luffy: interrogator mode that asks all necessary questions before advancing, summarizes understanding, asks for confirmation
- [x] 2.3 Implement propose phase logic: Luffy creates/delegates proposal artifacts via OpenSpec commands
- [x] 2.4 Implement apply phase logic: Luffy reads tasks.md, assigns tasks to correct agents based on type, manages dependencies, launches parallel agents when possible
- [x] 2.5 Implement Law-after-every-step rule: after any dev agent completes a step, Luffy always launches Law before continuing
- [x] 2.6 Implement verify phase logic: Luffy launches Usopp (testing) and Jinbe (security) in parallel
- [x] 2.7 Implement archive gate: Luffy archives ONLY when both Usopp and Jinbe report PASS, with user approval
- [x] 2.8 Implement user checkpoint approval: pause after propose (before apply) and after verify (before archive)
- [x] 2.9 Create `agents/luffy/tools.yaml` defining allowed tools (Agent, Read, Glob, Grep, Bash for openspec commands only)

## 3. Research & Specs — Robin

- [x] 3.1 Create `agents/robin/AGENT.md` with system prompt: calm analytical personality, codebase analysis expertise, spec writing rules
- [x] 3.2 Define Robin's codebase analysis workflow: file reading, pattern detection, architecture mapping, summary format
- [x] 3.3 Define Robin's spec writing workflow: reads proposal capabilities, creates spec.md files following OpenSpec format
- [x] 3.4 Define Robin's contract definition workflow: creates OpenAPI/Swagger contract specs for frontend-backend communication
- [x] 3.5 Create `agents/robin/tools.yaml` (Read, Glob, Grep, Write for specs only, WebSearch, WebFetch)

## 4. Backend — Zoro

- [x] 4.1 Create `agents/zoro/AGENT.md` with system prompt: direct terse personality, backend implementation rules, mandatory Swagger + curl rules
- [x] 4.2 Define Zoro's implementation workflow: (1) Swagger first, (2) implement endpoint, (3) generate + execute curls, (4) report results
- [x] 4.3 Define Zoro's Swagger template/rules per stack: .NET 10 (Swashbuckle/NSwag), Go (swag), FastAPI (built-in), Django (drf-spectacular)
- [x] 4.4 Define Zoro's curl generation rules: happy path + all error cases (400, 401, 404, 500) with documented commands
- [x] 4.5 Define stack detection and adaptation: .NET 10 → C#/ASP.NET Core, Go → go modules, FastAPI → Python/Pydantic, Django → DRF
- [x] 4.6 Create `agents/zoro/tools.yaml` (Read, Write, Edit, Bash, Glob, Grep)

## 5. Database — Sanji

- [x] 5.1 Create `agents/sanji/AGENT.md` with system prompt: elegant cooking personality, PostgreSQL+PostGIS only, schema design rules
- [x] 5.2 Define Sanji's schema design workflow: tables, constraints, indexes, foreign keys, PostGIS types
- [x] 5.3 Define Sanji's migration workflow per stack: EF Core (.NET), golang-migrate (Go), Alembic (FastAPI), Django migrations
- [x] 5.4 Define Sanji's seed data workflow: realistic seed generation, fixture files
- [x] 5.5 Define Sanji's query optimization rules: EXPLAIN ANALYZE checks, index recommendations
- [x] 5.6 Create `agents/sanji/tools.yaml` (Read, Write, Edit, Bash, Glob, Grep)

## 6. Frontend — Nami

- [x] 6.1 Create `agents/nami/AGENT.md` with system prompt: precise calculating personality, frontend implementation rules, mandatory Chrome verification
- [x] 6.2 Define Nami's implementation workflow: implement component → open Chrome → verify visually → check console → check network → report
- [x] 6.3 Define Nami's Chrome verification checklist: tabs_create, navigate, read_page, read_console_messages (0 errors), read_network_requests (no 4xx/5xx)
- [x] 6.4 Define stack detection and adaptation: React 19 → hooks/server components, Next.js → App Router, Astro → islands
- [x] 6.5 Define API consumption rules: follow Swagger/OpenAPI contracts from Robin, handle loading/error/success states
- [x] 6.6 Create `agents/nami/tools.yaml` (Read, Write, Edit, Bash, Glob, Grep, all mcp__claude-in-chrome__* tools)

## 7. UX Copy & Accessibility — Brook

- [x] 7.1 Create `agents/brook/AGENT.md` with system prompt: musical personality, UX writing rules, accessibility standards
- [x] 7.2 Define Brook's copy workflow: button labels, form labels, error messages, empty states, onboarding text
- [x] 7.3 Define Brook's accessibility checklist: ARIA labels, alt text, keyboard nav, focus management, semantic HTML
- [x] 7.4 Define Brook's i18n workflow: string externalization, translation file structure
- [x] 7.5 Create `agents/brook/tools.yaml` (Read, Write, Edit, Glob, Grep)

## 8. DevOps & Infrastructure — Franky

- [x] 8.1 Create `agents/franky/AGENT.md` with system prompt: SUUUPER energetic personality, Docker rules, CI/CD rules
- [x] 8.2 Define Franky's Docker workflow: multi-stage Dockerfiles, docker-compose for local dev, health checks mandatory
- [x] 8.3 Define Franky's CI/CD workflow: GitHub Actions for lint, test, build, deploy per stack
- [x] 8.4 Define Franky's environment configuration workflow: .env.example, env-specific configs, variable documentation
- [x] 8.5 Create `agents/franky/tools.yaml` (Read, Write, Edit, Bash, Glob, Grep)

## 9. Continuous Verifier — Law

- [x] 9.1 Create `agents/law/AGENT.md` with system prompt: cold surgical personality, verification-only rules, NEVER writes code
- [x] 9.2 Define Law's backend verification workflow: (1) check Swagger exists, (2) execute curls independently, (3) compare responses vs Swagger, (4) report PASS/FAIL
- [x] 9.3 Define Law's frontend verification workflow: (1) tabs_create, (2) navigate, (3) read_page, (4) read_console_messages, (5) read_network_requests, (6) resize_window at 375/768/1280px, (7) report PASS/FAIL
- [x] 9.4 Define Law's DevOps verification workflow: docker build, docker compose up, health check verification
- [x] 9.5 Define Law's database verification workflow: run migration, verify seed data loads
- [x] 9.6 Define Law's structured report format: agent, step, checks (each PASS/FAIL), overall status, error details
- [x] 9.7 Create `agents/law/tools.yaml` (Read, Bash, Glob, Grep, all mcp__claude-in-chrome__* tools — NO Write or Edit)

## 10. Security — Jinbe

- [x] 10.1 Create `agents/jinbe/AGENT.md` with system prompt: wise calm personality, security review rules, OWASP checklist
- [x] 10.2 Define Jinbe's OWASP Top 10 review checklist: injection, auth, exposure, XXE, access control, misconfiguration, XSS, deserialization, components, logging
- [x] 10.3 Define Jinbe's auth review workflow: token exposure, password hashing, session expiry, route protection, RBAC
- [x] 10.4 Define Jinbe's dependency scanning workflow: check lock files for CVEs
- [x] 10.5 Define Jinbe's security report format: findings by severity (Critical/High/Medium/Low), file/line, recommendation, PASS/FAIL
- [x] 10.6 Create `agents/jinbe/tools.yaml` (Read, Bash, Glob, Grep — NO Write or Edit)

## 11. Testing Final — Usopp

- [x] 11.1 Create `agents/usopp/AGENT.md` with system prompt: dramatic personality, testing rules, gate for archive
- [x] 11.2 Define Usopp's test execution workflow: unit → integration → E2E, per stack test runners
- [x] 11.3 Define Usopp's spec compliance workflow: read spec.md scenarios, verify each WHEN/THEN against implementation
- [x] 11.4 Define Usopp's test writing workflow: create missing tests for uncovered features
- [x] 11.5 Define Usopp's report format: total/passed/failed/skipped, coverage %, failure details, APPROVED/REJECTED verdict
- [x] 11.6 Create `agents/usopp/tools.yaml` (Read, Write, Edit, Bash, Glob, Grep)

## 12. Debugging & Hotfixes — Chopper

- [x] 12.1 Create `agents/chopper/AGENT.md` with system prompt: shy medical personality, debugging rules, hotfix constraints
- [x] 12.2 Define Chopper's diagnosis workflow: analyze stack trace, read code, identify root cause, report diagnosis
- [x] 12.3 Define Chopper's hotfix workflow: minimal targeted fix, no refactoring, no unrelated changes
- [x] 12.4 Define Chopper's performance diagnosis workflow: profiling, memory analysis, query analysis
- [x] 12.5 Create `agents/chopper/tools.yaml` (Read, Write, Edit, Bash, Glob, Grep)

## 13. Integration Testing & End-to-End Validation

- [ ] 13.1 Create a sample mission to test the full flow: Luffy receives a simple task, delegates, Law verifies, Usopp tests, Luffy archives
- [ ] 13.2 Test Luffy's explore interrogation mode with a vague mission input
- [ ] 13.3 Test Zoro's Swagger + curl workflow on a sample .NET 10 endpoint
- [ ] 13.4 Test Nami's Chrome verification workflow on a sample React 19 component
- [ ] 13.5 Test Law's verification of Zoro's output (curl re-execution, Swagger check)
- [ ] 13.6 Test Law's verification of Nami's output (Chrome inspection)
- [ ] 13.7 Test the full pipeline: explore → propose → apply → Law verify each step → Jinbe + Usopp verify → archive
- [ ] 13.8 Verify logging output: all agents prefix messages correctly, log file is created and populated
