## Why

Luffy (el agente orquestador) describe los comandos `/opsx:*` como texto plano en su `AGENT.md` pero nunca invoca la herramienta `Skill` del sistema. Esto provoca que el flujo OpenSpec no deje traza real: no se crean carpetas en `openspec/changes/`, no hay `proposal.md`, `specs/`, `design.md` ni `tasks.md` para ningún change. El trabajo existe solo en el contexto de la conversación y desaparece sin dejar registro estructurado ni historial auditable.

El sistema tiene dos capas complementarias que actualmente no se usan juntas:
- **OpenSpec CLI / Skill tool** = capa de traza y estructura (crea carpetas, gestiona ciclo de vida, archiva)
- **Agentes de la tripulación** = capa de ejecución (llenan el contenido, implementan, verifican)

Ambas capas deben activarse en cada flujo de desarrollo. Actualmente solo se activa la segunda.

## What Changes

1. **`agents/luffy/AGENT.md`** — Fase 2 (PROPOSE): reemplazar la instrucción de texto plano `Run: /opsx:propose <change-name>` por una invocación explícita al Skill tool (`Skill("opsx:propose")`) antes de que Robin llene los artifacts. Fase 5 (ARCHIVE): reemplazar `Run: /opsx:archive <change-name>` por `Skill("opsx:archive")`.

2. **`agents/luffy/tools.yaml`** — Agregar `Skill` a la lista `allowed_tools`, con nota de para qué se usa (comandos OpenSpec del flujo).

3. **`agents/shared/openspec-flow.md`** — Agregar en cada fase relevante (PROPOSE y ARCHIVE) una nota explícita de qué skill invocar y en qué momento exacto del flujo.

## Capabilities

### New Capabilities

_(ninguna — este change no agrega capacidades nuevas al sistema)_

### Modified Capabilities

- **orchestrator-luffy** — El orquestador ahora invoca el Skill tool para activar la capa de traza OpenSpec en las fases PROPOSE y ARCHIVE, en lugar de solo describir los comandos como texto
- **agent-logging** — El flujo de logging queda completo: los artifacts en `openspec/changes/` sirven como registro permanente del trabajo, complementando los logs de consola

## Impact

**Archivos modificados:**
- `agents/luffy/AGENT.md`
- `agents/luffy/tools.yaml`
- `agents/shared/openspec-flow.md`

**Propagación:** Los cambios en `agents/` se propagan inmediatamente a todos los proyectos instalados vía symlink. No se requiere re-ejecutar `setup.sh`.

**Sin cambios en:** `agents/commands/opsx/*.md` (copiados, no linkeados — fuera del alcance de este fix).
