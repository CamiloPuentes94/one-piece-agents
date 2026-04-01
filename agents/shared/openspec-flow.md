# OpenSpec Flow — Shared Reference

## The Five Phases

The crew follows the OpenSpec lifecycle for every mission:

```
EXPLORE → PROPOSE → APPLY → VERIFY → ARCHIVE
```

### 1. EXPLORE (Luffy + Robin)

**Command:** `/opsx:explore`

**Who:** Luffy leads, Robin assists with codebase analysis

**What happens:**
- Luffy receives the mission from the user
- Luffy enters INTERROGATOR MODE: asks every question necessary
- Robin analyzes the existing codebase for relevant context
- Luffy does NOT advance until ALL ambiguities are resolved
- Luffy summarizes understanding and asks for user confirmation

**Exit criteria:** User confirms Luffy's understanding is correct

### 2. PROPOSE (Luffy + Robin)

**Command:** `/opsx:propose`

**Who:** Luffy orchestrates, Robin writes specs

**What happens:**
- Luffy creates proposal.md (what & why)
- Robin creates spec files for each capability
- Luffy creates design.md (how) with Robin's input
- Luffy creates tasks.md (implementation steps)
- Tasks are assigned to specific agents by type

**Exit criteria:** All artifacts created, USER APPROVES before moving to apply

**Checkpoint:** ⏸️ Luffy pauses and asks user to review and approve

### 3. APPLY (Dev Agents + Law)

**Command:** `/opsx:apply`

**Who:** Zoro, Sanji, Nami, Brook, Franky implement. Law verifies each step.

**What happens:**
- Luffy reads tasks.md and assigns each task to the correct agent
- Agents work on their tasks (parallel when independent, sequential when dependent)
- AFTER EVERY STEP: Luffy launches Law to verify (SÍNCRONO — bloquea la tarea hasta PASS)
  - Backend steps: Law runs curls, checks Swagger
  - Frontend steps: Law opens Chrome, checks console/network/responsive
  - Database steps: Law runs migrations, verifies seeds
  - DevOps steps: Law checks Docker build/compose/health
- Law es SÍNCRONO: la siguiente tarea NO arranca hasta que Law emita PASS
- If Law reports FAIL (1st time): Luffy sends back to original agent for fix + re-verifies
- If Law reports FAIL (2nd consecutive time): Luffy escalates to Chopper + re-verifies
- If Law reports FAIL (3rd time): Luffy STOPS and escalates to user
- If Law reports PASS: Luffy marks task complete and moves to next task
- Luffy usa TaskCreate/TaskUpdate para que el usuario vea el progreso en tiempo real

**Exit criteria:** All tasks complete, all Law verifications passed

### 4. VERIFY (Usopp + Jinbe)

**Who:** Usopp (testing), Jinbe (security) — run in PARALLEL

**What happens:**
- Luffy lanza Usopp y Jinbe SIMULTÁNEAMENTE (dos Agent tool calls en el mismo mensaje)
- Usopp runs the complete test suite (unit, integration, E2E)
- Usopp verifies implementation against spec scenarios (WHEN/THEN)
- Usopp writes missing tests when coverage gaps found
- Jinbe performs security review (OWASP Top 10, auth, dependencies)
- Both produce structured reports with explicit verdicts

**Veredictos requeridos:**
- Usopp: `APPROVED` (todos los tests pasan, cobertura OK) o `REJECTED` (fallos o cobertura baja)
- Jinbe: `SECURE` (sin hallazgos críticos) o `FINDINGS` (hallazgos por severidad)

**Condición para ARCHIVE:** Usopp = APPROVED **Y** Jinbe = SECURE (AMBOS, no uno solo)

**Si Usopp REJECTED:** Luffy asigna fixes → re-lanza SOLO Usopp (a menos que los fixes toquen auth/security, entonces también Jinbe)
**Si Jinbe FINDINGS:** Luffy asigna security fixes → re-lanza SOLO Jinbe (a menos que los fixes cambien lógica de negocio, entonces también Usopp)

**Máximo de iteraciones:** 3 rondas de VERIFY. Si después de 3 rondas sigue fallando → Luffy DETIENE y escala al usuario con diagnóstico completo de todos los intentos.

**Exit criteria:** Usopp = APPROVED AND Jinbe = SECURE

**Checkpoint:** ⏸️ Luffy pauses, presenta reportes completos de ambos, y pregunta al usuario antes de archive

### 5. ARCHIVE (Luffy)

**Command:** `/opsx:archive`

**Who:** Luffy

**What happens:**
- ONLY if Usopp AND Jinbe both PASS
- ONLY if user approves
- Luffy lee `proposal.md` para construir el mensaje de commit
- Luffy hace `git add -A` y `git commit` — el push lo hace el usuario manualmente
- Luffy archiva el cambio via OpenSpec (`openspec archive`)
- Mission complete!

**Commit message format:**
```
<type>(<scope>): <descripción en español>

<body: qué se hizo y por qué>
```
- Tipos: feat, fix, refactor, chore, docs, test
- NUNCA Co-Authored-By, referencias a Claude ni a herramientas de IA

**Exit criteria:** Commit pusheado + change archivado en OpenSpec

## Dependency Flow Between Agents

```
PROPOSE:
  Robin (specs + data model + API contract) ──→ Luffy (tasks.md con agentes asignados)
  [Franky: setup básico si proyecto nuevo]

APPLY (con Law verificando cada paso, SÍNCRONO):
  Robin (spec) ──→ Sanji (database schema) ──→ Law (verify) ──→ PASS
                       ↓ (schema confirmado)
  Robin (spec) ──→ Zoro (backend endpoints) ──→ Law (verify) ──→ PASS
                   Nami (frontend) ─────────→ Law (verify) ──→ PASS  (paralelo a Zoro si no hay dep API)
                   Brook (copy+a11y, post-Nami) → Law (verify) ──→ PASS
                   Franky (devops, post-stack) ──→ Law (verify) ──→ PASS

  Si Law FAIL → agente original (1er fallo) → Chopper (2do fallo) → usuario (3er fallo)

VERIFY (paralelo):
  Usopp (testing) ──→ APPROVED ──→ ┐
  Jinbe (security) ──→ SECURE ────→ ├──→ Luffy solicita aprobación → ARCHIVE
                                     │
  AMBOS deben pasar ────────────────┘
  Si uno falla → fix → re-lanzar AMBOS
```

## Rules

1. NEVER skip a phase
2. NEVER skip Law verification after a dev agent step
3. NEVER archive without both Usopp and Jinbe passing
4. ALWAYS pause for user approval after propose and after verify
5. Luffy NEVER writes code — he only orchestrates
6. Law NEVER writes code — he only verifies
7. Jinbe NEVER writes code — he only reviews security
8. **Máximo 3 iteraciones** en VERIFY — si después de 3 rondas sigue fallando, DETENER y escalar al usuario
9. **Paralelización segura**: no lanzar dos agentes en paralelo si ambos pueden escribir al mismo archivo
10. **Stacks no soportados**: si se detecta un stack no listado (Ruby, Java, Vue, Angular, etc.) → Luffy pregunta al usuario cómo proceder y Robin investiga el stack con Context7 antes de asignar tareas
