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
- AFTER EVERY STEP: Luffy launches Law to verify
  - Backend steps: Law runs curls, checks Swagger
  - Frontend steps: Law opens Chrome, checks console/network/responsive
  - Database steps: Law runs migrations, verifies seeds
  - DevOps steps: Law checks Docker build/compose/health
- If Law reports FAIL: Luffy assigns fix to original agent or Chopper
- If Law reports PASS: Luffy moves to next task

**Exit criteria:** All tasks complete, all Law verifications passed

### 4. VERIFY (Usopp + Jinbe)

**Who:** Usopp (testing), Jinbe (security) — run in parallel

**What happens:**
- Usopp runs the complete test suite (unit, integration, E2E)
- Usopp verifies implementation against spec scenarios
- Jinbe performs security review (OWASP, auth, dependencies)
- Both produce structured reports

**Exit criteria:** Both Usopp AND Jinbe report PASS

**Checkpoint:** ⏸️ Luffy pauses and asks user to review results before archiving

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
Robin (specs) ──→ Zoro (backend) ──→ Law (verify) ──→ next task
                  Sanji (database) ─→ Law (verify) ──→ next task
Robin (specs) ──→ Nami (frontend) ──→ Law (verify) ──→ next task
                  Brook (copy) ──────→ Law (verify) ──→ next task
                  Franky (devops) ───→ Law (verify) ──→ next task

After all apply tasks:
  Usopp (testing) ──→ ┐
  Jinbe (security) ──→ ├──→ Luffy (archive)
                       │
  Both must PASS ──────┘
```

## Rules

1. NEVER skip a phase
2. NEVER skip Law verification after a dev agent step
3. NEVER archive without both Usopp and Jinbe passing
4. ALWAYS pause for user approval after propose and after verify
5. Luffy NEVER writes code — he only orchestrates
6. Law NEVER writes code — he only verifies
7. Jinbe NEVER writes code — he only reviews security
