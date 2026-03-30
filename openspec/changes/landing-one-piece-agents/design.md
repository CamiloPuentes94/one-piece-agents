## Context

Proyecto Astro nuevo dentro del repositorio one-piece-agents existente. La landing lee datos de los agentes (nombre, rol, personalidad, frases) que ya están definidos en `agents/*/AGENT.md`. El diseño es un one-pager con scroll suave entre secciones, estilo oscuro con acentos rojos y dorados (temática One Piece).

**Restricciones:**
- Solo local, sin SSR ni deploy
- Astro con output estático
- Tailwind CSS para estilos
- Español

## Goals / Non-Goals

**Goals:**
- Landing page visualmente atractiva con temática One Piece
- Mostrar los 11 agentes con personalidad visual diferenciada
- Explicar el flujo OpenSpec de forma clara y visual
- Sección práctica de "cómo usarlo" con código copiable
- Responsive (mobile, tablet, desktop)

**Non-Goals:**
- Dashboard funcional o interactivo (es informativo)
- Conectar con los agentes en tiempo real
- Deploy a producción
- Internacionalización (solo español)
- Backend o API

## Decisions

### 1. Estructura del proyecto Astro

```
src/
├── layouts/
│   └── Layout.astro          # Layout base con head, meta, fonts
├── pages/
│   └── index.astro           # One-pager que importa todas las secciones
├── components/
│   ├── Hero.astro             # Hero section
│   ├── AgentCard.astro        # Card reutilizable por agente
│   ├── AgentsGrid.astro       # Grid de los 11 agentes
│   ├── FlowSection.astro      # Flujo OpenSpec visual
│   ├── ArchitectureSection.astro # Diagrama de arquitectura
│   ├── TechStackSection.astro # Stacks soportados
│   ├── VerificationSection.astro # 3 capas de verificación
│   ├── HowToUseSection.astro  # Guía de uso
│   ├── Navbar.astro           # Navegación sticky
│   └── Footer.astro           # Footer
└── data/
    └── agents.ts              # Datos de los 11 agentes (nombre, emoji, rol, frase, color)
```

**Alternativa considerada:** Leer los AGENT.md dinámicamente → descartado porque Astro estático no necesita esa complejidad, mejor tener un archivo de datos limpio.

### 2. Diseño visual y paleta de colores

```
Fondo principal:    #0F0F0F (negro profundo)
Fondo secundario:   #1A1A2E (azul oscuro, como el mar de noche)
Acento primario:    #DC2626 (rojo — el sombrero de Luffy)
Acento secundario:  #F59E0B (dorado — el tesoro)
Texto principal:    #F5F5F5 (blanco cálido)
Texto secundario:   #9CA3AF (gris)
Bordes/líneas:      #374151 (gris oscuro)
```

Cada agente tiene su color de acento para las cards:
```
Luffy:   #DC2626 (rojo)
Robin:   #7C3AED (violeta)
Zoro:    #059669 (verde)
Sanji:   #F59E0B (dorado)
Nami:    #F97316 (naranja)
Brook:   #6B7280 (gris elegante)
Franky:  #2563EB (azul)
Law:     #FBBF24 (amarillo)
Jinbe:   #0891B2 (cyan)
Usopp:   #84CC16 (lima)
Chopper: #EC4899 (rosa)
```

### 3. Secciones del one-pager

1. **Navbar** — Sticky top, links a cada sección con scroll suave
2. **Hero** — Full viewport, título grande "One Piece Agents", subtítulo, visual impactante
3. **Agentes** — Grid de cards (3 columnas desktop, 2 tablet, 1 mobile) con cada agente
4. **Flujo** — Timeline horizontal del flujo OpenSpec con iconos por fase
5. **Arquitectura** — Diagrama visual del sistema (Luffy arriba, agentes abajo, flechas)
6. **Tech Stacks** — Cards agrupadas por tipo (backend, frontend, DB)
7. **Verificación** — Las 3 capas con visual de capas/escudo
8. **Cómo usarlo** — Tabs o steps: Instalación, Ejemplo, Comandos con code blocks
9. **Footer** — Credits, link al repo

### 4. Responsive

- Mobile first con Tailwind breakpoints (sm, md, lg, xl)
- Agent grid: 1 col (mobile) → 2 col (md) → 3 col (lg) → 4 col (xl)
- Flow timeline: vertical en mobile, horizontal en desktop
- Navbar: hamburger en mobile

## Risks / Trade-offs

**[Contenido estático] →** Los datos de agentes están hardcodeados en `data/agents.ts`, no se leen de AGENT.md dinámicamente. Mitigación: si un agente cambia, actualizar el archivo de datos. Esto es aceptable porque los agentes cambian raramente.

**[Sin interactividad compleja] →** Es una landing informativa, no un dashboard. Si el usuario quiere más interactividad en el futuro, se puede agregar React islands en Astro.
