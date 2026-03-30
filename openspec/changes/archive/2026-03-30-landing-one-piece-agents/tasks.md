## 1. Project Setup (Franky)

- [ ] 1.1 Initialize Astro project with Tailwind CSS in the repository root
- [ ] 1.2 Configure tailwind.config.mjs with One Piece color palette (rojo, negro, dorado, colores por agente)
- [ ] 1.3 Configure astro.config.mjs for static output

## 2. Data & Layout (Robin + Nami)

- [ ] 2.1 Create src/data/agents.ts with all 11 agents data (emoji, name, role, description, phrase, color)
- [ ] 2.2 Create src/layouts/Layout.astro with base HTML, meta tags, fonts, global styles

## 3. Components — Structure (Nami)

- [ ] 3.1 Create Navbar.astro — sticky navigation with links to all sections, smooth scroll
- [ ] 3.2 Create Hero.astro — full viewport hero with system name, tagline, CTA button
- [ ] 3.3 Create AgentCard.astro — reusable card component (emoji, name, role, description, phrase, accent color)
- [ ] 3.4 Create AgentsGrid.astro — responsive grid of 11 agent cards (1→2→3→4 columns)
- [ ] 3.5 Create FlowSection.astro — OpenSpec flow timeline (5 phases with agents per phase)
- [ ] 3.6 Create ArchitectureSection.astro — visual diagram of orchestrator→agents→verification
- [ ] 3.7 Create TechStackSection.astro — grouped tech stack cards (backend, frontend, DB)
- [ ] 3.8 Create VerificationSection.astro — 3 verification layers visualization
- [ ] 3.9 Create HowToUseSection.astro — installation, example mission, commands with code blocks
- [ ] 3.10 Create Footer.astro — credits and repo link

## 4. Page Assembly (Nami)

- [ ] 4.1 Assemble src/pages/index.astro importing all components in order with section IDs for navigation

## 5. Content & Copy (Brook)

- [ ] 5.1 Write all section headings, descriptions, and copy in Spanish
- [ ] 5.2 Write the example mission narrative for the How to Use section
- [ ] 5.3 Ensure all text is clear, engaging, and follows One Piece personality

## 6. Verification (Law → Chrome)

- [ ] 6.1 Verify page loads without console errors in Chrome
- [ ] 6.2 Verify all 11 agent cards render with correct data
- [ ] 6.3 Verify navbar smooth scroll works for all section links
- [ ] 6.4 Verify responsive: mobile (375px), tablet (768px), desktop (1280px)
- [ ] 6.5 Verify no broken network requests
