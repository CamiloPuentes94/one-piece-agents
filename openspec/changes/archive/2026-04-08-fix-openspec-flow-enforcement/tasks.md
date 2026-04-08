# Tasks — fix-openspec-flow-enforcement

## Tasks

### Task 1: Actualizar agents/luffy/tools.yaml

**Agent:** Robin
**Description:** Agregar `Skill` a la lista `allowed_tools` de Luffy con nota explicativa de uso exclusivo para comandos OpenSpec
**Files:** `agents/luffy/tools.yaml`
**Details:**
- Agregar `- Skill # EXCLUSIVAMENTE para comandos OpenSpec del flujo (/opsx:propose, /opsx:archive, etc.)` en el bloque `allowed_tools`, después de la entrada `mcp__claude_ai_Context7__query-docs`
- Agregar en la sección `notes`: "Luffy usa Skill EXCLUSIVAMENTE para los comandos del flujo OpenSpec (/opsx:propose, /opsx:archive). Para lanzar sub-agentes (Robin, Zoro, Nami, etc.) siempre usa Agent, nunca Skill."

---

### Task 2: Actualizar agents/luffy/AGENT.md — Fase 2 PROPOSE

**Agent:** Robin
**Description:** Reemplazar la instrucción de texto plano `Run: /opsx:propose` por invocación explícita al Skill tool en la Fase 2 del workflow de Luffy
**Files:** `agents/luffy/AGENT.md`
**Details:**
- Localizar el bloque de Phase 2: PROPOSE, paso 2: `Run: /opsx:propose <change-name>`
- Reemplazarlo por: instrucción de invocar `Skill("opsx:propose")` al inicio de la fase, seguida de la descripción de que Robin llena los artifacts en `openspec/changes/<change-name>/`
- Ver `design.md` para el texto exacto del reemplazo

---

### Task 3: Actualizar agents/luffy/AGENT.md — Fase 5 ARCHIVE

**Agent:** Robin
**Description:** Reemplazar la instrucción de texto plano `Run: /opsx:archive` por invocación explícita al Skill tool en la Fase 5 del workflow de Luffy, incluyendo el Output Format
**Files:** `agents/luffy/AGENT.md`
**Details:**
- Localizar el bloque de Phase 5: ARCHIVE, paso 7: `Run: /opsx:archive <change-name>`
- Reemplazarlo por: `Skill("opsx:archive")`
- Localizar en el bloque Output Format el log `[🏴‍☠️ LUFFY] ▶️ EJECUTANDO | openspec archive <change-name>`
- Reemplazarlo por: `[🏴‍☠️ LUFFY] ▶️ EJECUTANDO | Skill("opsx:archive")`
- Ver `design.md` para el texto exacto de cada reemplazo

---

### Task 4: Actualizar agents/shared/openspec-flow.md

**Agent:** Robin
**Description:** Agregar notas de skill invocado en las fases PROPOSE y ARCHIVE del documento de referencia compartido
**Files:** `agents/shared/openspec-flow.md`
**Details:**
- En la sección `### 2. PROPOSE`: agregar nota de `Skill("opsx:propose")` después de la línea `**Command:** \`/opsx:propose\``
- En la sección `### 5. ARCHIVE`: agregar nota de `Skill("opsx:archive")` después de la línea `**Command:** \`/opsx:archive\``
- Ver `design.md` para el texto exacto de cada nota
