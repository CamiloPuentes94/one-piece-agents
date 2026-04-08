# Design — fix-openspec-flow-enforcement

## Enfoque

Tres modificaciones quirúrgicas en archivos de configuración de agentes. No hay código de aplicación. No hay migraciones. No hay tests de infraestructura. Robin aplica los tres cambios directamente.

---

## Cambio 1: `agents/luffy/AGENT.md`

### Fase 2 — PROPOSE (línea ~170)

**Texto actual:**
```
2. Run: /opsx:propose <change-name>
   - Create proposal.md (what & why)
   - With Robin: create specs for each capability
   - Create design.md (how)
   - Create tasks.md (who does what)
```

**Texto nuevo:**
```
2. Invocar Skill tool para crear la estructura del change:
   Skill("opsx:propose")
   - Esto crea la carpeta openspec/changes/<change-name>/ con estructura base
3. Con Robin, llenar los artifacts del change:
   - Robin escribe proposal.md (what & why) en openspec/changes/<change-name>/
   - Robin crea specs/ para cada capability
   - Robin escribe design.md (how)
   - Luffy/Robin escriben tasks.md (who does what)
```

**Por qué:** El paso 2 debe ser la invocación real del Skill, no una descripción de texto. El Skill crea la estructura de carpetas. Robin llena el contenido después.

---

### Fase 5 — ARCHIVE (línea ~357)

**Texto actual:**
```
7. Run: /opsx:archive <change-name>
```

**Texto nuevo:**
```
7. Invocar Skill tool para archivar:
   Skill("opsx:archive")
```

**Por qué:** Igual que en PROPOSE — el comando debe ejecutarse como herramienta real, no como texto descriptivo.

---

### Output Format — Archive y commit (línea ~463)

**Texto actual:**
```
[🏴‍☠️ LUFFY] ▶️ EJECUTANDO | openspec archive <change-name>
```

**Texto nuevo:**
```
[🏴‍☠️ LUFFY] ▶️ EJECUTANDO | Skill("opsx:archive")
```

**Por qué:** El log debe reflejar qué herramienta se usa realmente.

---

## Cambio 2: `agents/luffy/tools.yaml`

**Agregar al bloque `allowed_tools`** (después de la línea de `mcp__claude_ai_Context7__query-docs`):

```yaml
  - Skill          # EXCLUSIVAMENTE para comandos OpenSpec del flujo (/opsx:propose, /opsx:archive, etc.)
```

**Agregar a la sección `notes`:**

```
Luffy usa Skill EXCLUSIVAMENTE para los comandos del flujo OpenSpec (/opsx:propose, /opsx:archive).
Para lanzar sub-agentes (Robin, Zoro, Nami, etc.) siempre usa Agent, nunca Skill.
```

---

## Cambio 3: `agents/shared/openspec-flow.md`

### Sección 2. PROPOSE

**Agregar después de `**Command:** \`/opsx:propose\``:**

```markdown
**Skill invocado por Luffy:** `Skill("opsx:propose")` — se ejecuta AL INICIO de la fase,
antes de que Robin llene los artifacts. Crea la carpeta `openspec/changes/<nombre>/`
con la estructura base para que Robin pueda escribir en ella.
```

### Sección 5. ARCHIVE

**Agregar después de `**Command:** \`/opsx:archive\``:**

```markdown
**Skill invocado por Luffy:** `Skill("opsx:archive")` — se ejecuta AL FINAL de la fase,
después del git commit. Mueve el change de `openspec/changes/` a `openspec/changes/archive/`.
```

---

## Orden de ejecución

Robin aplica los tres cambios en este orden:

1. `agents/luffy/tools.yaml` — más corto, establece el permiso
2. `agents/luffy/AGENT.md` — las dos fases (PROPOSE y ARCHIVE) + el Output Format
3. `agents/shared/openspec-flow.md` — las dos anotaciones de fase

No hay dependencias cruzadas entre los tres archivos — pueden revisarse en cualquier orden, pero se aplican en el orden listado para facilitar la revisión.

---

## Consideraciones

- **Sin cambios en `agents/commands/opsx/*.md`**: esos archivos son copiados (no linkeados) al instalar en proyectos. Requieren re-ejecutar setup para propagarse. Fuera del alcance de este fix.
- **Sin cambios en specs base**: `openspec/specs/orchestrator-luffy/spec.md` y `openspec/specs/agent-logging/spec.md` se actualizan vía sync cuando este change se archive.
- **Propagación inmediata**: los symlinks en proyectos instalados apuntan a `agents/`, por lo que los cambios son efectivos tan pronto como los archivos se editen.
