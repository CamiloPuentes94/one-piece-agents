## Context

Proyecto greenfield. No existe código previo — solo la configuración de OpenSpec. El sistema se construirá usando Claude Code Agent SDK para crear sub-agentes que se comunican mediante el patrón orquestador-trabajador. Cada agente es un archivo de configuración (system prompt + herramientas permitidas + reglas) que Claude Code instancia como sub-proceso.

El usuario necesita visibilidad total durante el afinamiento: cada acción de cada agente debe ser observable via logs en consola y archivo.

**Restricciones:**
- Los agentes deben funcionar dentro del ecosistema Claude Code (Agent tool, MCP tools)
- chrome verification usa las herramientas `mcp__claude-in-chrome__*` disponibles
- PostgreSQL+PostGIS es la única base de datos permitida
- Todo backend debe tener Swagger/OpenAPI y curls documentados

## Goals / Non-Goals

**Goals:**

- Sistema de 11 agentes especializados con personalidad One Piece que pueden construir sistemas completos
- Orquestador (Luffy) que gestiona el flujo OpenSpec end-to-end sin programar
- Luffy en explore es interrogador: no avanza hasta tener claridad total
- Verificación continua de 3 capas: Law (cada paso), Jinbe (seguridad), Usopp (final)
- Backend siempre con Swagger + curls ejecutados y documentados
- Frontend siempre verificado visualmente en Chrome
- Logging detallado con identidad de agente para visibilidad durante afinamiento
- Soporte multi-stack: .NET 10, Go, FastAPI, Django, React 19, Next.js, Astro

**Non-Goals:**

- Dashboard web de monitoreo (fase futura)
- Agentes que funcionen fuera de Claude Code (no es un framework independiente)
- Soporte para bases de datos que no sean PostgreSQL+PostGIS
- Auto-scaling o ejecución distribuida de agentes

## Decisions

### 1. Arquitectura: Claude Code Agent Definitions (`.md` files con CLAUDE.md override)

Cada agente se define como un archivo markdown con system prompt personalizado que se invoca via el Agent tool de Claude Code. El orquestador (Luffy) es el agente principal que corre en el contexto del usuario y lanza sub-agentes.

**Estructura:**
```
agents/
├── luffy/
│   ├── AGENT.md          # System prompt + personalidad + reglas
│   └── tools.yaml        # Herramientas permitidas para este agente
├── zoro/
│   ├── AGENT.md
│   └── tools.yaml
├── nami/
│   ├── AGENT.md
│   └── tools.yaml
├── law/
│   ├── AGENT.md
│   └── tools.yaml
├── ...cada agente
└── shared/
    ├── logging.md        # Reglas de logging compartidas
    └── openspec-flow.md  # Flujo OpenSpec compartido
```

**Alternativa considerada:** Un solo archivo con todos los agentes → descartado porque cada agente necesita prompts largos y específicos, y mantenerlos separados facilita el afinamiento individual.

### 2. Comunicación: Patrón Orquestador → Trabajador via Agent Tool

Luffy usa el `Agent tool` de Claude Code para lanzar sub-agentes con prompts específicos por tarea. Cada sub-agente recibe:
- La tarea concreta (del tasks.md de OpenSpec)
- Contexto del proyecto (del proposal/design)
- Sus reglas específicas (del AGENT.md)

El resultado del sub-agente regresa a Luffy, quien decide el siguiente paso.

```
LUFFY (main context)
  │
  ├── Agent(prompt="Zoro, implementa POST /api/users...", subagent_type="zoro")
  │     └── Retorna: código + curls + swagger
  │
  ├── Agent(prompt="Law, verifica el endpoint POST /api/users...", subagent_type="law")
  │     └── Retorna: ✅ verificado / ❌ errores encontrados
  │
  └── ...
```

**Alternativa considerada:** Message passing asíncrono → descartado porque Claude Code Agent tool es síncrono y es más simple para el afinamiento inicial.

### 3. Verificación de Law: Post-Step Hook

Después de que cualquier agente dev (Zoro, Nami, Sanji, Franky, Brook) completa un paso, Luffy SIEMPRE lanza a Law antes de continuar.

```
Para Backend (Zoro/Sanji):
  Law ejecuta:
  1. Verifica que Swagger/OpenAPI existe y está actualizado
  2. Ejecuta cada curl documentado
  3. Compara responses vs spec de Swagger
  4. Verifica status codes de error
  → Output: PASS/FAIL con detalle

Para Frontend (Nami/Brook):
  Law ejecuta:
  1. tabs_create_mcp → abre nueva pestaña
  2. navigate → va a la URL del componente/página
  3. read_page → verifica contenido renderizado
  4. read_console_messages → 0 errores JS
  5. read_network_requests → sin 4xx/5xx
  6. resize_window → verifica responsive (mobile, tablet, desktop)
  7. Opcionalmente: gif_creator → graba evidencia
  → Output: PASS/FAIL con screenshots/evidencia

Para DevOps (Franky):
  Law ejecuta:
  1. docker build → verifica que construye
  2. docker compose up → verifica que levanta
  3. health check endpoints → verifica que responden
  → Output: PASS/FAIL
```

### 4. Flujo OpenSpec Integrado en Luffy

Luffy mapea directamente los comandos OpenSpec a fases de trabajo:

| Fase | Quién actúa | Qué hace |
|------|-------------|----------|
| explore | Luffy + Robin | Luffy pregunta al usuario TODO lo necesario. Robin investiga el codebase. No avanzan hasta tener claridad. |
| propose | Luffy + Robin | Luffy crea proposal.md, Robin ayuda con specs, design emerge del análisis |
| apply | Zoro, Sanji, Nami, Brook, Franky | Cada uno implementa sus tareas. Law verifica cada paso. |
| verify | Usopp + Jinbe | Usopp corre test suite completa. Jinbe revisa seguridad. |
| archive | Luffy | Solo si Usopp y Jinbe dan ✅. Luffy archiva el cambio. |

### 5. Logging: Formato con identidad de agente

Cada agente prefija sus mensajes con su identidad:

```
[🏴‍☠️ LUFFY] Recibió misión: "Sistema de autenticación"
[📚 ROBIN] Analizando codebase... 47 archivos relevantes encontrados
[🏴‍☠️ LUFFY] Creando proposal...
[⚔️ ZORO]  Implementando POST /api/auth/login
[⚔️ ZORO]  Swagger documentado ✅
[⚔️ ZORO]  Curl test: 200 OK ✅
[⚕️ LAW]   Verificando endpoint POST /api/auth/login...
[⚕️ LAW]   Swagger completo ✅ | Curl 200 ✅ | Error 401 ✅ | Error 400 ✅
[🏴‍☠️ LUFFY] → NAMI: Implementa login page
[🗺️ NAMI]  Creando componente LoginForm...
[⚕️ LAW]   Verificando en Chrome... 0 console errors ✅ | Responsive ✅
```

Cada línea se imprime en consola Y se escribe a un archivo `.log` por sesión.

### 6. Personalidad: System Prompts con Voz

Cada AGENT.md incluye:
- Rol y responsabilidades exactas
- Herramientas permitidas (whitelist)
- Reglas estrictas (swagger obligatorio, chrome obligatorio, etc.)
- Voz del personaje (frases, estilo de comunicación)
- Interacciones con otros agentes (a quién consulta, a quién entrega)

## Risks / Trade-offs

**[Context window de sub-agentes] →** Cada sub-agente tiene contexto limitado. Mitigación: Luffy pasa solo el contexto relevante (la tarea, los specs necesarios, los archivos relevantes).

**[Tiempo de ejecución] →** 11 agentes secuenciales puede ser lento. Mitigación: Luffy paraleliza agentes independientes (Zoro y Nami en paralelo cuando no hay dependencias). Law corre después de cada uno, no al final de todos.

**[Afinamiento de prompts] →** Los system prompts necesitan iteración. Mitigación: cada agente es un archivo separado, fácil de modificar individualmente. El logging permite ver exactamente qué hace cada agente.

**[Chrome tools pueden fallar] →** Las herramientas de chrome dependen de la extensión corriendo. Mitigación: Law reporta si no puede verificar en Chrome en lugar de bloquear todo el flujo. El usuario puede verificar manualmente.

**[Multi-stack complejidad] →** Soportar 4 backends y 3 frontends significa prompts largos por agente. Mitigación: Zoro detecta el stack del proyecto actual y adapta su comportamiento. No necesita saber todos los stacks simultáneamente.
