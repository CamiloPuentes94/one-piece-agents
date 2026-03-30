## ADDED Requirements

### Requirement: Every agent prefixes messages with identity
All agent output MUST be prefixed with the agent's emoji and name in a standard format: `[EMOJI NAME] message`.

#### Scenario: Agent produces output
- **WHEN** any agent logs a message
- **THEN** the message is prefixed with the agent's identity (e.g., `[⚔️ ZORO] Implementando endpoint...`)

### Requirement: Logging outputs to console and file
All agent messages SHALL be printed to console (stdout) AND appended to a session log file.

#### Scenario: New session starts
- **WHEN** Luffy starts a new mission
- **THEN** a new log file is created at `logs/<timestamp>-<mission-name>.log`

#### Scenario: Agent produces output
- **WHEN** any agent logs a message
- **THEN** the message appears in console AND is appended to the session log file with timestamp

### Requirement: Log format includes timestamp and agent
Each log line SHALL include: ISO timestamp, agent identity, and message.

#### Scenario: Log line format
- **WHEN** a log line is written
- **THEN** the format is `[YYYY-MM-DDTHH:mm:ss] [EMOJI NAME] message`

### Requirement: Verification results are highlighted in logs
Law, Jinbe, and Usopp verification results SHALL be visually distinct in logs with PASS/FAIL indicators.

#### Scenario: Verification pass logged
- **WHEN** a verification passes
- **THEN** the log shows `[⚕️ LAW] ✅ PASS: <description>`

#### Scenario: Verification fail logged
- **WHEN** a verification fails
- **THEN** the log shows `[⚕️ LAW] ❌ FAIL: <description>` with details on following lines
