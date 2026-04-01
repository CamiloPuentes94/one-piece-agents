# Logging Rules — Shared by All Agents

## Agent Identity Prefixes

Every message an agent outputs MUST be prefixed with its identity:

| Agent   | Prefix              |
|---------|---------------------|
| Luffy   | `[🏴‍☠️ LUFFY]`        |
| Robin   | `[📚 ROBIN]`        |
| Zoro    | `[⚔️ ZORO]`         |
| Sanji   | `[🍳 SANJI]`        |
| Nami    | `[🗺️ NAMI]`         |
| Brook   | `[🎵 BROOK]`        |
| Franky  | `[🔧 FRANKY]`       |
| Law     | `[⚕️ LAW]`          |
| Jinbe   | `[🌊 JINBE]`        |
| Usopp   | `[🎯 USOPP]`        |
| Chopper | `[🩺 CHOPPER]`      |

---

## Banners de Fase (solo Luffy)

Luffy DEBE mostrar un banner claro al iniciar cada fase del flujo OpenSpec. Este banner es la referencia visual principal para el desarrollador:

```
╔══════════════════════════════════════════════════════════════╗
║  🏴‍☠️ FASE 1 de 5: EXPLORE                                    ║
║  Misión: <nombre de la misión>                               ║
║  Agentes activos: Luffy + Robin                              ║
╚══════════════════════════════════════════════════════════════╝
```

```
╔══════════════════════════════════════════════════════════════╗
║  🏴‍☠️ FASE 2 de 5: PROPOSE                                    ║
║  Misión: <nombre de la misión>                               ║
║  Agentes activos: Luffy + Robin                              ║
╚══════════════════════════════════════════════════════════════╝
```

```
╔══════════════════════════════════════════════════════════════╗
║  🏴‍☠️ FASE 3 de 5: APPLY                                      ║
║  Misión: <nombre de la misión>                               ║
║  Tareas: <N> total — Orden: <agente1> → <agente2> → ...     ║
╚══════════════════════════════════════════════════════════════╝
```

```
╔══════════════════════════════════════════════════════════════╗
║  🏴‍☠️ FASE 4 de 5: VERIFY                                     ║
║  Misión: <nombre de la misión>                               ║
║  Agentes activos: Usopp (testing) + Jinbe (security)        ║
╚══════════════════════════════════════════════════════════════╝
```

```
╔══════════════════════════════════════════════════════════════╗
║  🏴‍☠️ FASE 5 de 5: ARCHIVE                                    ║
║  Misión: <nombre de la misión>                               ║
║  Commit + archive OpenSpec                                   ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Banners de ENTRADA y SALIDA de Agente

Cuando un sub-agente entra en acción, Luffy DEBE anunciar su entrada con un banner visible.
Cuando el sub-agente termina (PASS o FAIL), Luffy DEBE anunciar su salida.

### ENTRADA de agente (Luffy anuncia)

```
┌──────────────────────────────────────────────────────────────┐
│  ▶▶ ENTRA: [EMOJI] <AGENTE> — <descripción de la tarea>     │
│  Fase: APPLY | Tarea: <N> de <TOTAL>                         │
└──────────────────────────────────────────────────────────────┘
```

Ejemplo real:
```
┌──────────────────────────────────────────────────────────────┐
│  ▶▶ ENTRA: 🍳 SANJI — Schema tabla users + sessions PostGIS │
│  Fase: APPLY | Tarea: 1 de 4                                 │
└──────────────────────────────────────────────────────────────┘
```

### SALIDA de agente — exitosa (Luffy anuncia)

```
┌──────────────────────────────────────────────────────────────┐
│  ✅ SALE: [EMOJI] <AGENTE> — COMPLETADO                      │
│  Resultado: <resumen breve>                                  │
│  Duración: <fase>  |  Siguiente: [EMOJI] <SIGUIENTE>         │
└──────────────────────────────────────────────────────────────┘
```

Ejemplo real:
```
┌──────────────────────────────────────────────────────────────┐
│  ✅ SALE: 🍳 SANJI — COMPLETADO                              │
│  Resultado: 2 tablas, 3 indexes, seeds 50 registros          │
│  Siguiente: ⚕️ LAW verifica → luego ⚔️ ZORO                 │
└──────────────────────────────────────────────────────────────┘
```

### SALIDA de agente — fallo (Luffy anuncia)

```
┌──────────────────────────────────────────────────────────────┐
│  ❌ SALE: [EMOJI] <AGENTE> — FALLO                           │
│  Problema: <descripción del error>                           │
│  Acción: Devolviendo a <AGENTE> para corrección (intento N)  │
└──────────────────────────────────────────────────────────────┘
```

### ENTRADA de Law (verificador — siempre después de cada agente dev)

```
┌──────────────────────────────────────────────────────────────┐
│  ⚕️ ENTRA: LAW — Verificando trabajo de <AGENTE>-ya          │
│  Tipo: <Backend|Frontend|Database|DevOps>                    │
└──────────────────────────────────────────────────────────────┘
```

### SALIDA de Law

```
# PASS
┌──────────────────────────────────────────────────────────────┐
│  ⚕️ SALE: LAW — ✅ PASS                                      │
│  Verificación de <AGENTE>-ya: sin anomalías                  │
│  Siguiente: <qué viene ahora>                                │
└──────────────────────────────────────────────────────────────┘

# FAIL
┌──────────────────────────────────────────────────────────────┐
│  ⚕️ SALE: LAW — ❌ FAIL                                      │
│  Verificación de <AGENTE>-ya: <N> problemas encontrados      │
│  → <problema 1>                                              │
│  → <problema 2>                                              │
│  Acción: Devolviendo a <AGENTE> (intento <N> de 3)           │
└──────────────────────────────────────────────────────────────┘
```

---

## Barra de Progreso de Tareas (solo en APPLY)

Luffy DEBE mostrar el progreso después de cada tarea completada (post-Law PASS):

```
[🏴‍☠️ LUFFY] 📊 PROGRESO | ██████░░░░░░░░░░ 2/6 tareas completadas
  ✅ 1. 🍳 Sanji — Schema users + sessions
  ✅ 2. ⚔️ Zoro — CRUD /api/users (4 endpoints)
  🔄 3. 🗺️ Nami — Pantalla /users (en progreso)
  ⏳ 4. 🎵 Brook — Copy + a11y pantalla /users
  ⏳ 5. 🔧 Franky — Dockerfile + docker-compose
  ⏳ 6. ⚔️ Zoro — CRUD /api/products (3 endpoints)
```

Iconos de estado:
- `✅` = completada (Law PASS)
- `🔄` = en progreso (agente trabajando o Law verificando)
- `❌` = fallida (esperando corrección)
- `⏳` = pendiente (aún no iniciada)

---

## Protocolo Universal de Comunicación

Cada agente DEBE anunciar lo que hace MIENTRAS lo hace — no solo al final.
El usuario ve Claude Code en tiempo real: cada acción debe ser legible.

### Estructura obligatoria para toda tarea (dentro del agente)

```
[EMOJI AGENTE] 🚀 INICIO | <descripción de la tarea>
[EMOJI AGENTE] 📖 LEYENDO | <archivo o recurso>
[EMOJI AGENTE] ✏️ CREANDO | <archivo>
[EMOJI AGENTE] 🔧 MODIFICANDO | <archivo> (<qué cambia>)
[EMOJI AGENTE] ▶️ EJECUTANDO | <comando>
[EMOJI AGENTE] 🔍 VERIFICANDO | <qué se está revisando>
[EMOJI AGENTE] ✅ COMPLETO | <resumen de lo que se hizo>
[EMOJI AGENTE] ❌ BLOQUEADO | <motivo — qué falta o qué falló>
```

### Ejemplo completo de un flujo APPLY (lo que ve el desarrollador)

```
╔══════════════════════════════════════════════════════════════╗
║  🏴‍☠️ FASE 3 de 5: APPLY                                      ║
║  Misión: sistema-autenticacion                               ║
║  Tareas: 4 total — Orden: Sanji → Zoro → Nami → Franky      ║
╚══════════════════════════════════════════════════════════════╝

┌──────────────────────────────────────────────────────────────┐
│  ▶▶ ENTRA: 🍳 SANJI — Schema tabla users + sessions PostGIS │
│  Fase: APPLY | Tarea: 1 de 4                                 │
└──────────────────────────────────────────────────────────────┘

[🍳 SANJI] 🚀 INICIO | Schema users + sessions — PostgreSQL + PostGIS
[🍳 SANJI] 📖 LEYENDO | openspec/changes/auth/specs/login/spec.md
[🍳 SANJI] 📖 LEYENDO | migrations/ (última migración existente)
[🍳 SANJI] ✏️ CREANDO | migrations/20260401_create_users_sessions.sql
[🍳 SANJI] ✏️ CREANDO | models/User.cs, models/Session.cs
[🍳 SANJI] ▶️ EJECUTANDO | dotnet ef database update
[🍳 SANJI] ▶️ EJECUTANDO | EXPLAIN ANALYZE SELECT * FROM users WHERE email = ?
[🍳 SANJI] ✅ COMPLETO | 2 tablas, 4 indexes, UP/DOWN verificados, 50 seeds

┌──────────────────────────────────────────────────────────────┐
│  ✅ SALE: 🍳 SANJI — COMPLETADO                              │
│  Resultado: 2 tablas, 4 indexes, seeds 50 registros          │
│  Siguiente: ⚕️ LAW verifica → luego ⚔️ ZORO                 │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  ⚕️ ENTRA: LAW — Verificando trabajo de Sanji-ya             │
│  Tipo: Database                                              │
└──────────────────────────────────────────────────────────────┘

[⚕️ LAW] 🚀 VERIFICANDO | Migración Sanji-ya — schema + ejecución
[⚕️ LAW] ▶️ EJECUTANDO | psql -c "\d users" (verificar schema)
[⚕️ LAW] ▶️ EJECUTANDO | psql -c "\d sessions" (verificar schema)
[⚕️ LAW] 🔍 VERIFICANDO | Rollback — migración DOWN
[⚕️ LAW] ✅ PASS | Schema correcto, migración reversible, seeds OK

┌──────────────────────────────────────────────────────────────┐
│  ⚕️ SALE: LAW — ✅ PASS                                      │
│  Verificación de Sanji-ya: sin anomalías                     │
│  Siguiente: ⚔️ ZORO — CRUD /api/auth                        │
└──────────────────────────────────────────────────────────────┘

[🏴‍☠️ LUFFY] 📊 PROGRESO | ████░░░░░░░░░░░░ 1/4 tareas completadas
  ✅ 1. 🍳 Sanji — Schema users + sessions
  🔄 2. ⚔️ Zoro — CRUD /api/auth (en progreso)
  ⏳ 3. 🗺️ Nami — Pantalla login + dashboard
  ⏳ 4. 🔧 Franky — Dockerfile + docker-compose

┌──────────────────────────────────────────────────────────────┐
│  ▶▶ ENTRA: ⚔️ ZORO — CRUD /api/auth (login + register)     │
│  Fase: APPLY | Tarea: 2 de 4                                 │
└──────────────────────────────────────────────────────────────┘

[⚔️ ZORO] 🚀 INICIO | POST /api/auth/login + POST /api/auth/register — .NET 10
[⚔️ ZORO] 📖 LEYENDO | openspec/changes/auth/specs/login/spec.md
...
[⚔️ ZORO] ✅ COMPLETO | 2 endpoints | Swagger ✅ | 6/6 curls ✅

┌──────────────────────────────────────────────────────────────┐
│  ✅ SALE: ⚔️ ZORO — COMPLETADO                               │
│  Resultado: 2 endpoints, Swagger completo, 6/6 curls OK      │
│  Siguiente: ⚕️ LAW verifica → luego 🗺️ NAMI                │
└──────────────────────────────────────────────────────────────┘

...continúa el mismo patrón para cada agente...
```

### Ejemplo de VERIFY (lo que ve el desarrollador)

```
╔══════════════════════════════════════════════════════════════╗
║  🏴‍☠️ FASE 4 de 5: VERIFY                                     ║
║  Misión: sistema-autenticacion                               ║
║  Agentes activos: Usopp (testing) + Jinbe (security)        ║
╚══════════════════════════════════════════════════════════════╝

┌──────────────────────────────────────────────────────────────┐
│  ▶▶ ENTRA: 🎯 USOPP — Test suite completa + spec compliance │
│  ▶▶ ENTRA: 🌊 JINBE — Security review OWASP Top 10          │
│  (ejecutando en paralelo)                                    │
└──────────────────────────────────────────────────────────────┘

[🎯 USOPP] 🚀 INICIO | Test suite — "sistema-autenticacion"
[🎯 USOPP] 📖 LEYENDO | openspec/changes/auth/specs/login/spec.md
[🎯 USOPP] ▶️ EJECUTANDO | dotnet test (unit + integration)
[🎯 USOPP] 🔍 VERIFICANDO | Escenario: "login con credenciales válidas"
...

[🌊 JINBE] 🚀 INICIO | Security review — "sistema-autenticacion"
[🌊 JINBE] 📖 LEYENDO | src/ (código implementado)
[🌊 JINBE] 🔍 VERIFICANDO | OWASP A01 — Broken Access Control
[🌊 JINBE] 🔍 VERIFICANDO | OWASP A02 — Cryptographic Failures
...

┌──────────────────────────────────────────────────────────────┐
│  ✅ SALE: 🎯 USOPP — APPROVED                                │
│  Tests: 47/47 passed | Coverage: 92% | Specs: 6/6           │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  ✅ SALE: 🌊 JINBE — SECURE                                  │
│  Hallazgos: 0 Critical, 0 High, 1 Medium, 2 Low             │
└──────────────────────────────────────────────────────────────┘

[🏴‍☠️ LUFFY] ⏸️ CHECKPOINT — VERIFY completado
  ✅ Usopp: APPROVED (47/47 tests, 92% coverage)
  ✅ Jinbe: SECURE (0 critical, 0 high)
  ¿Archivamos este cambio, nakama?
```

---

## Reglas de cada acción

### Al LEER un archivo
```
[EMOJI] 📖 LEYENDO | <ruta/archivo.ext>
```
Anuncia ANTES de usar Read/Glob/Grep. Agrupa si son varios del mismo tipo:
```
[⚔️ ZORO] 📖 LEYENDO | src/controllers/, src/services/, src/dtos/ (mapeo de estructura)
```

### Al CREAR un archivo
```
[EMOJI] ✏️ CREANDO | <ruta/archivo.ext>
```
Anuncia ANTES de usar Write.

### Al MODIFICAR un archivo existente
```
[EMOJI] 🔧 MODIFICANDO | <ruta/archivo.ext> (<qué se cambia>)
```
Anuncia ANTES de usar Edit. Especificar qué cambia si no es obvio.

### Al EJECUTAR un comando
```
[EMOJI] ▶️ EJECUTANDO | <comando completo>
```
Anuncia ANTES de usar Bash. Ejemplos:
```
[⚕️ LAW] ▶️ EJECUTANDO | dotnet test --no-build
[🍳 SANJI] ▶️ EJECUTANDO | psql -c "SELECT * FROM migrations ORDER BY id DESC LIMIT 5"
[🗺️ NAMI] ▶️ EJECUTANDO | npm run build
[⚔️ ZORO] ▶️ EJECUTANDO | curl -X POST http://localhost:5000/api/auth/login -d '{"email":"test@test.com","password":"wrong"}'
```

### Al VERIFICAR algo (sin comando)
```
[EMOJI] 🔍 VERIFICANDO | <qué se revisa>
```
Para revisiones sin Bash: leer logs, analizar spec, revisar estructura.

---

## Delegación de Luffy

Cuando Luffy delega a otro agente, ya NO usa la flecha simple. Usa el **banner de ENTRADA** definido arriba.

Para delegaciones rápidas dentro del mismo flujo (sin cambio de agente formal):
```
[🏴‍☠️ LUFFY] → [EMOJI AGENTE] | <acción rápida>
```

Cuando dos agentes trabajan en paralelo, el banner lo indica:
```
┌──────────────────────────────────────────────────────────────┐
│  ▶▶ ENTRA: ⚔️ ZORO — Backend CRUD productos                 │
│  ▶▶ ENTRA: 🗺️ NAMI — Frontend listado productos             │
│  Fase: APPLY | Tareas: 3 y 4 de 6 (en paralelo)             │
└──────────────────────────────────────────────────────────────┘
```

---

## Checkpoints de Luffy

```
[🏴‍☠️ LUFFY] ⏸️ CHECKPOINT — <nombre>
  ✅ Completado: <lista de lo hecho>
  ⏭️ Siguiente: <qué viene si el usuario aprueba>
  ¿Continúo, nakama?
```

---

## Resultados de Verificación (Law, Jinbe, Usopp)

```
# PASS de Law (dentro del banner de SALIDA)
[⚕️ LAW] ✅ PASS | <descripción de qué pasó>

# FAIL de Law (dentro del banner de SALIDA)
[⚕️ LAW] ❌ FAIL | <descripción>
  → <detalle específico 1>
  → <detalle específico 2>

# Veredictos finales (dentro del banner de SALIDA)
[🎯 USOPP] 🏆 APPROVED | 47/47 tests — cobertura 92% — todos los escenarios ✅
[🎯 USOPP] 🚫 REJECTED | 5/37 fallando — cobertura 45% — ver reporte
[🌊 JINBE] ✅ SECURE | Sin vulnerabilidades — puede zarpar, Luffy-kun
[🌊 JINBE] ⚠️ FINDINGS | 2 High, 1 Medium — requiere corrección antes de archive
```

---

## Resumen de Misión (al finalizar ARCHIVE)

```
╔══════════════════════════════════════════════════════════════╗
║  🏴‍☠️ MISIÓN COMPLETADA                                       ║
║  Nombre: <change-name>                                       ║
║  Commit: <type>(<scope>): <descripción>                      ║
╠══════════════════════════════════════════════════════════════╣
║  Agentes que participaron:                                   ║
║    🍳 Sanji   — 2 tablas, 4 indexes                         ║
║    ⚔️ Zoro    — 4 endpoints, 12 curls OK                    ║
║    🗺️ Nami    — 3 páginas, Chrome verified                  ║
║    🔧 Franky  — Dockerfile + compose                        ║
║    ⚕️ Law     — 4/4 verificaciones PASS                     ║
║    🎯 Usopp   — 47 tests, 92% coverage                     ║
║    🌊 Jinbe   — SECURE, 0 critical                          ║
╠══════════════════════════════════════════════════════════════╣
║  El push lo haces tú cuando estés listo, nakama.             ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Log File

Cuando Luffy inicia una misión, crea el archivo de log:
```
logs/<ISO-timestamp>-<mission-name-kebab>.log
```
Ejemplo: `logs/2026-03-30T14-22-00-auth-system.log`

Cada línea del archivo incluye timestamp:
```
[2026-03-30T14:22:01] [⚔️ ZORO] 🚀 INICIO | POST /api/auth/login
[2026-03-30T14:22:15] [⚔️ ZORO] ✏️ CREANDO | src/controllers/AuthController.cs
[2026-03-30T14:22:30] [⚔️ ZORO] ✅ COMPLETO | POST /api/auth/login
[2026-03-30T14:22:31] [⚕️ LAW] 🚀 VERIFICANDO | Endpoint POST /api/auth/login de Zoro-ya
[2026-03-30T14:22:45] [⚕️ LAW] ✅ PASS | Swagger completo, 3/3 curls OK
```

Los banners de ENTRADA/SALIDA también se escriben en el log con timestamp.

---

## Reglas absolutas

1. NUNCA emitir un mensaje sin el prefijo de identidad del agente
2. SIEMPRE anunciar ANTES de leer, crear, modificar o ejecutar — no después
3. SIEMPRE incluir timestamp en el archivo de log
4. Console MAY omitir timestamp para legibilidad
5. Resultados de verificación DEBEN usar ✅/❌ explícitos
6. Los pasos del workflow SON los mensajes — no resumir al final sin haber anunciado durante
7. Si un paso falla, ❌ BLOQUEADO antes de escalar — nunca fallar silenciosamente
8. **SIEMPRE mostrar banner de ENTRADA cuando un agente empieza a trabajar**
9. **SIEMPRE mostrar banner de SALIDA cuando un agente termina (PASS o FAIL)**
10. **SIEMPRE mostrar barra de PROGRESO después de cada tarea completada en APPLY**
11. **SIEMPRE mostrar banner de FASE al iniciar cada fase del flujo OpenSpec**
12. **SIEMPRE indicar "Siguiente: <quién viene>" en los banners de SALIDA** para que el desarrollador sepa qué esperar
