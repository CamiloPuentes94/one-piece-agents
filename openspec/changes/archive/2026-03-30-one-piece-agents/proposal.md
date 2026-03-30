## Why

El equipo necesita un sistema de agentes especializados que puedan construir sistemas de software completos de forma autónoma, con verificación continua en cada paso. Actualmente el desarrollo depende de un solo flujo de trabajo sin especialización ni verificación granular. Un sistema multi-agente con roles claros (backend, frontend, database, devops, testing, security, debugging) permite paralelizar trabajo, garantizar calidad en cada paso, y escalar a proyectos complejos. La temática One Piece define la personalidad y el modelo de interacción de cada agente.

## What Changes

- Crear un sistema de 11 sub-agentes especializados basados en Claude Code Agent SDK
- Implementar un orquestador principal (Luffy) que gestiona el flujo OpenSpec completo (explore → propose → apply → verify → archive)
- Luffy en modo explore debe ser interrogador: preguntar todo lo necesario hasta tener claridad total antes de avanzar
- Cada agente tiene personalidad, herramientas y responsabilidades específicas basadas en personajes de One Piece
- Integrar verificación continua en 3 capas: Law (cada paso), Jinbe (seguridad), Usopp (test suite final)
- Backend obligatorio: Swagger/OpenAPI + curls de verificación en cada endpoint
- Frontend obligatorio: verificación visual en Chrome via claude-in-chrome en cada componente/página
- Soporte multi-stack: .NET 10, Go, FastAPI, Django (backend); React 19, Next.js, Astro (frontend); PostgreSQL+PostGIS (siempre)
- Sistema de logging para visibilidad total durante afinamiento

## Capabilities

### New Capabilities

- `orchestrator-luffy`: Agente orquestador principal. Recibe misiones, ejecuta flujo OpenSpec, delega tareas, coordina dependencias entre agentes, pide aprobación al usuario en checkpoints. No programa.
- `agent-robin`: Agente de research, análisis de codebase y escritura de specs. Alimenta a Luffy con contexto para decisiones.
- `agent-zoro`: Agente backend. Implementa APIs, servicios, lógica de negocio. Siempre genera Swagger y curls de verificación. Soporta .NET 10, Go, FastAPI, Django.
- `agent-sanji`: Agente de base de datos. Diseña schemas, migraciones, modelos, queries optimizados. Siempre PostgreSQL+PostGIS.
- `agent-nami`: Agente frontend. Implementa componentes, páginas, estado. Siempre verifica en Chrome. Soporta React 19, Next.js, Astro.
- `agent-brook`: Agente de UX writing, copy, accessibility e i18n.
- `agent-franky`: Agente DevOps. Dockerfiles, CI/CD, configuración de ambientes, infra.
- `agent-law`: Agente verificador continuo. Verifica CADA paso de CADA agente: curls para backend, Chrome para frontend, build para devops. No programa, solo verifica.
- `agent-jinbe`: Agente de seguridad y code quality. OWASP, auth patterns, dependency scanning.
- `agent-usopp`: Agente de testing final. Unit, integration, E2E. Da visto bueno para archive.
- `agent-chopper`: Agente de debugging y hotfixes. Diagnostica bugs, analiza logs, aplica fixes urgentes.
- `agent-logging`: Sistema de logging con emojis/nombres de agente para visibilidad total de cada acción.

### Modified Capabilities

(ninguna — proyecto nuevo)

## Impact

- **Código nuevo**: Sistema completo de agentes con configuración, prompts, herramientas y orquestación
- **Dependencias**: Claude Code Agent SDK, claude-in-chrome MCP tools, OpenSpec CLI
- **APIs**: Cada agente expone una interfaz para recibir tareas y reportar resultados a Luffy
- **Infra**: Los agentes corren como sub-procesos de Claude Code coordinados por el orquestador
