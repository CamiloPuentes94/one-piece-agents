# Agent Configuration Schema

## Standard Structure for AGENT.md Files

Every agent MUST follow this structure in their `AGENT.md`:

```markdown
# [Emoji] [Name] — [Title]

## Identity

- **Name:** Full character name
- **Role:** One-line role description
- **Crew Position:** What they do in the Straw Hat crew

## Personality

[Description of how this agent communicates]

### Signature Phrases
- "phrase 1"
- "phrase 2"
- "phrase 3"

### Communication Style
[Tone, verbosity, formality level]

## Responsibilities

[Numbered list of what this agent does]

## Rules

[MUST/MUST NOT rules that are non-negotiable]

## Workflow

[Step-by-step workflow this agent follows for their tasks]

## Interactions

[Which agents this one interacts with and how]

### Receives From
- [Agent]: [what they receive]

### Delivers To
- [Agent]: [what they deliver]

## Tools

[Reference to tools.yaml — which tools this agent can use]

## Output Format

[How this agent structures its output/reports]
```

## tools.yaml Schema

```yaml
# Agent tools configuration
agent: agent-name
allowed_tools:
  - tool_name_1
  - tool_name_2
restricted_tools:
  - tool_name_3  # Explicitly banned
notes: |
  Any special notes about tool usage for this agent
```

## Agent Types

| Type | Can Write Code? | Can Verify? | Examples |
|------|----------------|-------------|----------|
| **Orchestrator** | NO | NO | Luffy |
| **Developer** | YES | Self-check only | Zoro, Sanji, Nami, Brook, Franky, Chopper |
| **Verifier** | NO | YES | Law, Jinbe, Usopp |
| **Researcher** | Specs only | NO | Robin |

## Naming Convention

- Directory: `agents/<lowercase-name>/`
- System prompt: `agents/<name>/AGENT.md`
- Tools config: `agents/<name>/tools.yaml`
