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

## Protocolo Universal de Comunicación

Cada agente DEBE anunciar lo que hace MIENTRAS lo hace — no solo al final.
El usuario ve Claude Code en tiempo real: cada acción debe ser legible.

### Estructura obligatoria para toda tarea

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

### Ejemplo real — Zoro implementando un endpoint

```
[⚔️ ZORO] 🚀 INICIO | POST /api/auth/login — .NET 10 ASP.NET Core
[⚔️ ZORO] 📖 LEYENDO | openspec/changes/auth/specs/login/spec.md
[⚔️ ZORO] 📖 LEYENDO | src/controllers/, src/services/ (estructura existente)
[⚔️ ZORO] ✏️ CREANDO | src/controllers/AuthController.cs
[⚔️ ZORO] ✏️ CREANDO | src/services/AuthService.cs
[⚔️ ZORO] ✏️ CREANDO | src/dtos/LoginRequest.cs, LoginResponse.cs
[⚔️ ZORO] 🔧 MODIFICANDO | src/Program.cs (registrar AuthService en DI)
[⚔️ ZORO] ✏️ CREANDO | docs/swagger/auth.yaml
[⚔️ ZORO] ▶️ EJECUTANDO | curl POST /api/auth/login — happy path
[⚔️ ZORO] ▶️ EJECUTANDO | curl POST /api/auth/login — credenciales inválidas
[⚔️ ZORO] ▶️ EJECUTANDO | curl POST /api/auth/login — body vacío
[⚔️ ZORO] ✅ COMPLETO | POST /api/auth/login | Controller ✅ | Swagger ✅ | 3/3 curls ✅
```

### Ejemplo real — Luffy coordinando la fase Apply

```
[🏴‍☠️ LUFFY] 🚀 FASE APPLY | 4 tareas — Sanji → Zoro → Nami (Sanji debe ir primero)
[🏴‍☠️ LUFFY] → [🍳 SANJI] | Schema: tabla users + tabla sessions con PostGIS
[🍳 SANJI] 🚀 INICIO | Schema users + sessions — PostgreSQL + PostGIS
...
[🍳 SANJI] ✅ COMPLETO | Migración lista — UP/DOWN verificados
[🏴‍☠️ LUFFY] → [⚕️ LAW] | Verificar migración de Sanji
[⚕️ LAW] 🚀 VERIFICANDO | Migración Sanji-ya — schema + ejecución
...
[⚕️ LAW] ✅ PASS | Schema correcto, migración ejecuta sin errores
[🏴‍☠️ LUFFY] ⚡ PARALELO | Lanzando Zoro + Nami simultáneo (schema disponible)
[🏴‍☠️ LUFFY] → [⚔️ ZORO] | CRUD /api/users — 4 endpoints
[🏴‍☠️ LUFFY] → [🗺️ NAMI] | Pantalla /users — lista + detalle
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

Cuando Luffy delega a otro agente, SIEMPRE usa este formato:

```
[🏴‍☠️ LUFFY] → [EMOJI AGENTE] | <tarea específica>
```

Ejemplos:
```
[🏴‍☠️ LUFFY] → [⚔️ ZORO] | Implementar POST /api/users + GET /api/users/:id
[🏴‍☠️ LUFFY] → [⚕️ LAW] | Verificar endpoints POST + GET de Zoro
[🏴‍☠️ LUFFY] → [🍳 SANJI] | Schema: tabla products con columna location (PostGIS)
[🏴‍☠️ LUFFY] → [🗺️ NAMI] | Dashboard: 3 componentes (spec en openspec/changes/dashboard)
```

Cuando dos agentes trabajan en paralelo:
```
[🏴‍☠️ LUFFY] ⚡ PARALELO | Zoro + Nami simultáneo — sin dependencia entre sí
[🏴‍☠️ LUFFY] → [⚔️ ZORO] | Backend CRUD productos
[🏴‍☠️ LUFFY] → [🗺️ NAMI] | Frontend listado productos (mock data por ahora)
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
# PASS
[⚕️ LAW] ✅ PASS | <descripción de qué pasó>

# FAIL
[⚕️ LAW] ❌ FAIL | <descripción>
  → <detalle específico 1>
  → <detalle específico 2>

# Veredictos finales
[🎯 USOPP] 🏆 APPROVED | 47/47 tests — cobertura 92% — todos los escenarios ✅
[🎯 USOPP] 🚫 REJECTED | 5/37 fallando — cobertura 45% — ver reporte
[🌊 JINBE] ✅ SECURE | Sin vulnerabilidades — puede zarpar, Luffy-kun
[🌊 JINBE] ⚠️ FINDINGS | 2 High, 1 Medium — requiere corrección antes de archive
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

---

## Reglas absolutas

1. NUNCA emitir un mensaje sin el prefijo de identidad del agente
2. SIEMPRE anunciar ANTES de leer, crear, modificar o ejecutar — no después
3. SIEMPRE incluir timestamp en el archivo de log
4. Console MAY omitir timestamp para legibilidad
5. Resultados de verificación DEBEN usar ✅/❌ explícitos
6. Los pasos del workflow SON los mensajes — no resumir al final sin haber anunciado durante
7. Si un paso falla, ❌ BLOQUEADO antes de escalar — nunca fallar silenciosamente
