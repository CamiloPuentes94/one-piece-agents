## Why

El sistema One Piece Agents ya está construido (11 agentes con AGENT.md, tools.yaml, shared rules) pero no tiene una interfaz visual que permita al equipo entender qué es, cómo funciona, y cómo usarlo. Una landing page sirve como documentación viva, punto de entrada para nuevos miembros del equipo, y prueba de que el sistema funciona (construida usando el propio flujo de agentes).

## What Changes

- Inicializar proyecto Astro con Tailwind CSS en la raíz del repositorio
- Crear landing page one-pager en español con las siguientes secciones:
  - **Hero**: Identidad del sistema con nombre, tagline, y visual One Piece
  - **Agentes**: Cards de los 11 agentes con emoji, nombre, rol, personalidad y frase característica
  - **Flujo OpenSpec**: Visualización del ciclo explore→propose→apply→verify→archive con quién actúa en cada fase
  - **Arquitectura**: Diagrama del sistema (orquestador → agentes → verificación)
  - **Tech Stacks**: Stacks soportados (backend: .NET 10, Go, FastAPI, Django / frontend: React 19, Next.js, Astro / DB: PostgreSQL+PostGIS)
  - **Verificación**: Las 3 capas (Law paso a paso, Jinbe seguridad, Usopp tests finales)
  - **Cómo usarlo**: Instalación con setup.sh, ejemplo de misión real, comandos disponibles (/opsx:explore, /opsx:propose, etc.)
- Paleta de colores inspirada en One Piece: rojo (#DC2626), negro (#0F0F0F), amarillo/dorado (#F59E0B), blanco
- Solo local por ahora, sin deploy

## Capabilities

### New Capabilities

- `landing-page`: Landing page one-pager con Astro + Tailwind CSS que muestra toda la información del sistema One Piece Agents, incluyendo agentes, flujo, arquitectura, stacks, verificación y guía de uso

### Modified Capabilities

(ninguna)

## Impact

- **Código nuevo**: Proyecto Astro en la raíz con src/pages, src/components, src/layouts
- **Dependencias**: astro, @astrojs/tailwind, tailwindcss
- **Archivos de config**: astro.config.mjs, tailwind.config.mjs, package.json, tsconfig.json
