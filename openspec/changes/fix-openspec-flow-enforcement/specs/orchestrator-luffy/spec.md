# orchestrator-luffy — Delta Spec (fix-openspec-flow-enforcement)

> Este es un spec delta. Solo documenta los cambios respecto al spec base en
> `openspec/specs/orchestrator-luffy/spec.md`. Los requirements no mencionados
> aquí permanecen sin cambios.

## Modified Requirement: Luffy manages the full OpenSpec flow

El orquestador SHALL invocar explícitamente el Skill tool para activar la capa de traza
OpenSpec en las fases PROPOSE y ARCHIVE. No es suficiente con describir los comandos
como texto — el Skill tool debe ejecutarse para que existan artifacts reales en
`openspec/changes/<nombre>/`.

### Scenario: Luffy entra a fase PROPOSE

- **WHEN** Luffy recibe misión de desarrollo y el usuario confirma entrar a PROPOSE
- **THEN** Luffy invoca `Skill("opsx:propose")` antes de que Robin comience a llenar artifacts
- **AND** la carpeta `openspec/changes/<nombre>/` se crea con la estructura base
- **AND** Robin escribe `proposal.md`, `specs/`, `design.md` y `tasks.md` dentro de esa carpeta

### Scenario: Robin llena los artifacts del change

- **WHEN** Luffy invoca el Skill de PROPOSE y la carpeta del change existe
- **THEN** Robin escribe los artifacts directamente en `openspec/changes/<nombre>/` usando Write/Edit
- **AND** los archivos son persistentes y auditables, no solo texto en la conversación

### Scenario: Luffy entra a fase ARCHIVE

- **WHEN** Usopp reporta APPROVED Y Jinbe reporta SECURE Y el usuario aprueba archivar
- **THEN** Luffy invoca `Skill("opsx:archive")` para mover el change a `openspec/changes/archive/`
- **AND** el commit git se construye a partir del `proposal.md` archivado
- **AND** el change queda registrado permanentemente en el historial de OpenSpec

### Scenario: Luffy describe el flujo sin invocar el Skill tool

- **WHEN** Luffy menciona `/opsx:propose` o `/opsx:archive` como texto en su respuesta
  sin invocar la herramienta Skill
- **THEN** este comportamiento es INCORRECTO — no cumple con este spec
- **AND** los artifacts no existen en el sistema de archivos
- **AND** no hay traza del trabajo más allá de la conversación activa

## New Requirement: Luffy usa Skill tool para comandos OpenSpec

El orquestador SHALL tener `Skill` en su lista de herramientas permitidas y SHALL
usarlo específicamente para los comandos del flujo OpenSpec.

### Scenario: Skill tool disponible en tools.yaml

- **WHEN** se revisa `agents/luffy/tools.yaml`
- **THEN** `Skill` está listado en `allowed_tools`
- **AND** la nota explica que se usa exclusivamente para comandos OpenSpec del flujo

### Scenario: Skill tool NO se usa para otras tareas

- **WHEN** Luffy necesita lanzar un sub-agente (Robin, Zoro, Nami, etc.)
- **THEN** Luffy usa la herramienta `Agent` (no `Skill`)
- **AND** `Skill` se reserva exclusivamente para los comandos `/opsx:*`
