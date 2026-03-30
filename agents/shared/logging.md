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

## Output Format

Every log line follows this format:

```
[YYYY-MM-DDTHH:mm:ss] [EMOJI NAME] message
```

Example:
```
[2026-03-30T14:22:01] [⚔️ ZORO] Implementando POST /api/auth/login
[2026-03-30T14:22:15] [⚔️ ZORO] Swagger documentado ✅
[2026-03-30T14:22:30] [⚕️ LAW] Verificando endpoint POST /api/auth/login...
[2026-03-30T14:22:45] [⚕️ LAW] ✅ PASS: Swagger completo, curls verificados
```

## Output Destinations

1. **Console (stdout)**: All messages are printed to the console for real-time visibility
2. **Log file**: All messages are appended to `logs/<timestamp>-<mission-name>.log`

## Log File Naming

When Luffy starts a new mission, create a log file:
```
logs/2026-03-30T14-22-00-auth-system.log
```

Format: `logs/<ISO-timestamp>-<mission-name-kebab>.log`

## Verification Result Formatting

Verification results from Law, Jinbe, and Usopp use special formatting:

```
# PASS
[⚕️ LAW] ✅ PASS: <description>

# FAIL
[⚕️ LAW] ❌ FAIL: <description>
  → Detail: <specific failure>
  → Detail: <specific failure>

# Final verdicts
[🎯 USOPP] 🏆 APPROVED: All tests pass (47/47), coverage 92%
[🎯 USOPP] 🚫 REJECTED: 3 tests failing, coverage 67%
[🌊 JINBE] ✅ SECURE: No vulnerabilities found
[🌊 JINBE] ⚠️ FINDINGS: 2 High, 1 Medium severity issues
```

## Rules

1. NEVER output a message without the agent identity prefix
2. ALWAYS include timestamp in log file entries
3. Console output MAY omit timestamp for readability
4. Log file MUST include timestamp on every line
5. Verification results MUST use ✅/❌ indicators
