## ADDED Requirements

### Requirement: Landing page renders as one-pager with all sections
The landing page SHALL render as a single-page application with smooth scroll navigation between sections: Hero, Agentes, Flujo, Arquitectura, Tech Stacks, Verificación, and Cómo Usarlo.

#### Scenario: Full page load
- **WHEN** user navigates to localhost
- **THEN** the page loads with all 8 sections visible via scroll, navbar with links to each section, and no JavaScript errors in console

### Requirement: Hero section displays system identity
The hero section SHALL display the system name "One Piece Agents", a tagline describing the system, and a visual element referencing One Piece.

#### Scenario: Hero renders
- **WHEN** user views the hero section
- **THEN** the system name "One Piece Agents" is visible as a large heading, a descriptive tagline is shown below, and there is a call-to-action button scrolling to the agents section

### Requirement: Agents section shows all 11 agents as cards
The agents grid SHALL display a card for each of the 11 agents with: emoji, character name, role, a brief description, and a signature phrase.

#### Scenario: All agents visible
- **WHEN** user scrolls to the agents section
- **THEN** 11 agent cards are displayed, each with the agent's emoji, name (Luffy, Robin, Zoro, Sanji, Nami, Brook, Franky, Law, Jinbe, Usopp, Chopper), their role, and at least one signature phrase

#### Scenario: Agent cards are color-coded
- **WHEN** agent cards render
- **THEN** each card has a distinct accent color matching the agent's identity

### Requirement: Flow section visualizes the OpenSpec lifecycle
The flow section SHALL display the 5 phases (EXPLORE, PROPOSE, APPLY, VERIFY, ARCHIVE) with which agents participate in each phase.

#### Scenario: Flow timeline renders
- **WHEN** user scrolls to the flow section
- **THEN** 5 phases are displayed in order with phase name, description, and participating agents listed for each

### Requirement: Architecture section shows system diagram
The architecture section SHALL display a visual representation of the orchestrator pattern: Luffy at the top delegating to dev agents, with Law verifying, and Usopp+Jinbe at the end.

#### Scenario: Architecture diagram renders
- **WHEN** user scrolls to the architecture section
- **THEN** a diagram shows Luffy as orchestrator connected to the dev agents (Zoro, Sanji, Nami, Brook, Franky) with Law as verification step and Usopp+Jinbe as final gates

### Requirement: Tech Stacks section lists all supported technologies
The tech stacks section SHALL list all supported backend, frontend, and database technologies.

#### Scenario: Stacks are grouped and visible
- **WHEN** user scrolls to the tech stacks section
- **THEN** three groups are shown: Backend (.NET 10, Go, FastAPI, Django), Frontend (React 19, Next.js, Astro), Database (PostgreSQL + PostGIS)

### Requirement: Verification section explains the 3 layers
The verification section SHALL explain the 3 verification layers: Law (continuous), Jinbe (security), Usopp (final testing).

#### Scenario: Three layers visible
- **WHEN** user scrolls to the verification section
- **THEN** three distinct layers are displayed with: Law — verifica cada paso, Jinbe — seguridad y OWASP, Usopp — test suite final y gate para archive

### Requirement: How to Use section provides practical guide
The how-to-use section SHALL include installation steps, a real mission example, and available commands.

#### Scenario: Installation steps visible
- **WHEN** user views the installation subsection
- **THEN** the setup.sh command is shown in a code block with explanation

#### Scenario: Example mission visible
- **WHEN** user views the example subsection
- **THEN** a step-by-step example shows a mission going through explore→propose→apply→verify→archive

#### Scenario: Commands visible
- **WHEN** user views the commands subsection
- **THEN** all available commands are listed: /opsx:explore, /opsx:propose, /opsx:apply, /opsx:verify, /opsx:archive

### Requirement: Navbar provides smooth scroll navigation
The navbar SHALL be sticky at the top and provide links to each section with smooth scroll behavior.

#### Scenario: Navigation click
- **WHEN** user clicks a navbar link
- **THEN** the page smoothly scrolls to the corresponding section

### Requirement: Page is responsive
The page SHALL be responsive across mobile (375px), tablet (768px), and desktop (1280px+).

#### Scenario: Mobile layout
- **WHEN** viewport is 375px wide
- **THEN** agent cards stack in 1 column, flow timeline is vertical, navbar collapses

#### Scenario: Desktop layout
- **WHEN** viewport is 1280px+ wide
- **THEN** agent cards display in 3-4 columns, flow timeline is horizontal, navbar shows all links
