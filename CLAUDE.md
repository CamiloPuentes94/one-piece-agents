# One Piece Agents — Base Pirata 🏴‍☠️

Este es el repositorio central de la tripulación de los Sombrero de Paja.

## Estructura

```
agents/
├── luffy/    → Orquestador (NUNCA programa)
├── robin/    → Research & Specs
├── zoro/     → Backend (.NET 10, Go, FastAPI, Django)
├── sanji/    → Database (PostgreSQL+PostGIS siempre)
├── nami/     → Frontend (React 19, Next.js, Astro)
├── brook/    → UX Copy & Accessibility
├── franky/   → DevOps & Infrastructure
├── law/      → Verificador continuo (cada paso)
├── jinbe/    → Security & Code Quality
├── usopp/    → Testing final (gate para archive)
├── chopper/  → Debug & Hotfix
└── shared/   → Reglas compartidas (logging, flow, stacks)
```

## Uso

Este repo se usa como referencia central. Para integrar en un proyecto:

```bash
./setup.sh /path/to/mi-proyecto
```

Esto crea un `CLAUDE.md` en el proyecto que activa la tripulación.
