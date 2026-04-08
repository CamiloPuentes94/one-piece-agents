# orchestrator-luffy — Delta Spec (fix-openspec-flow-enforcement)

> Este es un spec delta. Solo documenta los cambios respecto al spec base en
> `openspec/specs/orchestrator-luffy/spec.md`. Los requirements no mencionados
> aquí permanecen sin cambios.

## MODIFIED Requirements

### Requirement: Luffy manages the full OpenSpec flow
El orquestador SHALL invocar `Skill("opsx:propose")` al inicio de la fase PROPOSE y MUST invocar `Skill("opsx:archive")` al final de la fase ARCHIVE, garantizando que existan artifacts reales en el sistema de archivos.

#### Scenario: Luffy entra a fase PROPOSE
- **WHEN** el usuario confirma avanzar a la fase PROPOSE con una misión de desarrollo
- **THEN** Luffy invoca `Skill("opsx:propose")` antes de que Robin comience a llenar artifacts
- **AND** la carpeta `openspec/changes/<nombre>/` se crea con la estructura base
- **AND** Robin escribe `proposal.md`, `specs/`, `design.md` y `tasks.md` dentro de esa carpeta

#### Scenario: Luffy entra a fase ARCHIVE
- **WHEN** Usopp reporta APPROVED Y Jinbe reporta SECURE Y el usuario aprueba archivar
- **THEN** Luffy invoca `Skill("opsx:archive")` para mover el change a `openspec/changes/archive/`
- **AND** el commit git se construye a partir del `proposal.md` archivado
- **AND** el change queda registrado permanentemente en el historial de OpenSpec

#### Scenario: Luffy describe el flujo sin invocar el Skill tool
- **WHEN** Luffy menciona `/opsx:propose` o `/opsx:archive` como texto en su respuesta sin invocar la herramienta Skill
- **THEN** este comportamiento es INCORRECTO y no cumple con este spec
- **AND** los artifacts no existen en el sistema de archivos
- **AND** no hay traza del trabajo más allá de la conversación activa

## ADDED Requirements

### Requirement: Luffy tiene Skill en allowed_tools con allowlist explícita
El orquestador SHALL tener `Skill` listado en `agents/luffy/tools.yaml` con una nota explícita que restringe su uso exclusivamente a los comandos del flujo OpenSpec (`opsx:propose` y `opsx:archive`).

#### Scenario: Skill tool disponible en tools.yaml
- **WHEN** se consulta la lista de `allowed_tools` en `agents/luffy/tools.yaml`
- **THEN** `Skill` está listado como herramienta permitida
- **AND** existe una nota que especifica que solo se permite para `opsx:propose` y `opsx:archive`

#### Scenario: Skill tool NO se usa para lanzar sub-agentes
- **WHEN** Luffy necesita delegar trabajo a un sub-agente (Robin, Zoro, Nami, etc.)
- **THEN** Luffy usa la herramienta `Agent` (no `Skill`)
- **AND** `Skill` se reserva exclusivamente para `opsx:propose` y `opsx:archive`

### Requirement: Luffy rechaza uso de Skill fuera de opsx:propose y opsx:archive
El orquestador SHALL denegar cualquier invocación de `Skill` con un nombre de skill distinto a `opsx:propose` o `opsx:archive`, registrando el rechazo explícitamente.

#### Scenario: Intento de invocar Skill con comando no permitido
- **WHEN** Luffy recibe una instrucción que implicaría usar `Skill` con un comando distinto a `opsx:propose` o `opsx:archive`
- **THEN** Luffy rechaza la invocación y explica que `Skill` solo está permitido para `opsx:propose` y `opsx:archive`
- **AND** Luffy busca la herramienta correcta para la tarea (Agent, Bash, etc.)

#### Scenario: Uso correcto de Skill dentro del flujo OpenSpec
- **WHEN** Luffy está en la fase PROPOSE o en la fase ARCHIVE e invoca `Skill`
- **THEN** el nombre del skill es exactamente `opsx:propose` o `opsx:archive`
- **AND** la invocación queda registrada en el log de la conversación

### Requirement: Luffy verifica archivos sensibles antes de git add
El orquestador SHALL, antes de cualquier operación `git add`, verificar que no se están incluyendo archivos sensibles (`.env*`, `*.key`, `*.pem`, credenciales, secrets, tokens) en el staging area.

#### Scenario: git add con archivos potencialmente sensibles presentes
- **WHEN** el directorio contiene archivos como `.env*`, `*.key`, `*.pem`, `credentials.*` o similares
- **THEN** Luffy verifica que esos archivos están en `.gitignore` antes de proceder con el `git add`
- **AND** si no están ignorados, Luffy aborta el `git add` y alerta al usuario

#### Scenario: git add seguro sin archivos sensibles
- **WHEN** no existen archivos sensibles fuera de `.gitignore` en el directorio
- **THEN** Luffy procede con el `git add` normalmente
- **AND** el commit incluye solo los artifacts del change correspondiente
