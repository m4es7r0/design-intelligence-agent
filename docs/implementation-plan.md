# Design Intelligence Agent Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the design intelligence system from `docs/superpowers/specs/2026-07-27-design-intelligence-agent-design.md`: one orchestrator skill (`design-agent`) with six reference modules + README, a rewritten `design-scout` researcher agent, and reworked forks of `mobile-design-patterns` and `ersatz-design`.

**Architecture:** All deliverables are Markdown instruction files (skills/agents), no executable code. `design-agent` is the single user entry point; it resolves platform first, then context, mode, research (via `design-scout` dispatches), synthesis, generation routing, verification. Reference files carry the method so SKILL.md stays lean.

**Tech Stack:** Claude Code skills (`~/.claude/skills/*/SKILL.md` with YAML frontmatter `name`+`description`), Claude Code agents (`~/.claude/agents/*.md` with frontmatter `name`/`description`/`tools`/`model`), plain Markdown references.

## Global Constraints

- Spec is the source of truth: `docs/superpowers/specs/2026-07-27-design-intelligence-agent-design.md` (committed as f6b8078).
- `~/.claude` is NOT a git repository — no git steps for files there; backup via `.bak` copies. Only this plan/spec in the test-app repo get commits.
- Absolute target paths: `/Users/dmitromusijcenko/.claude/skills/...` and `/Users/dmitromusijcenko/.claude/agents/...`.
- Bodies in English. Frontmatter `description` includes bilingual RU+EN trigger phrases.
- Shared vocabulary — use these exact strings everywhere:
  - Provenance labels: `SOURCE`, `SYNTHESIS`, `SPECULATION`, `MODEL-KNOWLEDGE`
  - Modes: `explore`, `grounded`, `hybrid` (default), `audit`, `prototype`, `cross-platform-synthesis`
  - sourceType enum: `official-guideline | official-design-system | real-shipped-product | case-study-or-research | concept-or-visual-inspiration`
  - Source tiers: `Tier A` (normative), `Tier B` (real shipped products), `Tier C` (research/case studies), `Tier D` (concepts/visual inspiration; never usability evidence)
  - Search rings: `Ring 0` exact match, `Ring 1` adjacent products same task, `Ring 2` same interaction pattern other domains, `Ring 3` official systems & standards, `Ring 4` experimental
  - Scoring dimensions (0–5 each) with rank weights: `taskFit 25%`, `platformFit 20%`, `domainFit 15%`, `evidenceQuality 15%`, `transferability 10%`, `freshness 10%`, `visualRelevance 5%`
  - Platform targets: `ios | android | cross-platform-mobile | responsive-web | desktop-web | mobile-web`
  - Severity taxonomy (mobile fork): `Standard violation`, `Platform convention conflict`, `Usability risk`, `Design-system inconsistency`, `Visual polish`, `Subjective preference`
  - Rule types: `platform rule`, `usability heuristic`, `product convention`, `visual preference`
  - Free screen libraries: vp0.com, banani.co, pageflows.com, uisources.com, mobbin.com (free tier only)
- Size budgets: design-agent SKILL.md ≤ ~200 lines; each reference file ≤ ~160 lines; platforms/ios.md and android.md ≤ ~80 lines each.
- Never fabricate sources, links, or dates anywhere; fallback output must be labeled `MODEL-KNOWLEDGE`.
- Responsibility boundaries (spec §5) must appear in the owning file: scout researches only; ersatz never blank-slate; mobile/web modules never drive workflow; verification runs post-synthesis.

---

### Task 1: `design-agent` SKILL.md (orchestrator)

**Files:**
- Create: `/Users/dmitromusijcenko/.claude/skills/design-agent/SKILL.md`
- Create dir: `/Users/dmitromusijcenko/.claude/skills/design-agent/references/`

**Interfaces:**
- Produces: the workflow contract every other file plugs into. Exact reference filenames it cites: `references/modes.md`, `references/research-method.md`, `references/platform-profiles.md`, `references/web-platform.md`, `references/output-formats.md`, `references/verification.md`. Exact agent name it dispatches: `design-scout` (modes `quick` / `survey`). Exact skills it routes to: `mobile-design-patterns`, `ersatz-design`, builders (expo-*, hallmark, frontend-design, coss, figma skills).
- Consumes: nothing (first file).

- [x] **Step 1: Write SKILL.md** with this structure (verbatim frontmatter; sections as listed; prose fills each section per the spec sections cited):

```markdown
---
name: design-agent
description: |
  Design Intelligence orchestrator — the primary entry point for any non-trivial design work: finding design references, choosing patterns, exploring directions, auditing designs, running full design cycles and prototyping. Grounds decisions in live research instead of LLM defaults. Use for: "найди реффы/референсы", "как это делают", "какой паттерн тут уместен", "исследуй направления", "спроектируй экран/страницу", "редизайн", "design research", "find references", "what's the current pattern", "explore design directions", "design this screen/page/flow". For non-trivial design work invoke THIS skill, not ersatz-design or mobile-design-patterns directly — it orchestrates them in the right order (research before generation).
---
```

Body sections (H2), in order:
1. `# Design Intelligence Agent` + 3-line role statement: orchestrator that owns context, routing, final decisions, final output; sub-components never make final decisions (spec §5 boundary).
2. `## Invariants` — bullet list, verbatim content from spec §4 "Invariants": platform resolves before everything; no silent cross-platform mixing; ersatz-design never first and never without research_summary + approved pattern decisions (except labeled SPECULATION); grounded/hybrid forbid evidence-free generation; explore requires SPECULATION labels; fallback output never presented as live-verified (label MODEL-KNOWLEDGE); output size scales to the ask.
3. `## Step 1 — Platform Router (mandatory first)` — resolve BEFORE research and before invoking any design skill. Fields block (verbatim):

```
family: mobile | web | cross-platform
target: ios | android | cross-platform-mobile | responsive-web | desktop-web | mobile-web
primary / secondary platform
formFactor: phone | large-phone | tablet | foldable | desktop | wide-desktop
inputMethods: touch | mouse | trackpad | keyboard | stylus
implementation: framework / styling / component library
confidence: high | medium | low
assumptions: explicit list
```

   Resolution priority: user-stated > detected from materials (RN/Expo code, Next.js, screenshots, Figma frame width) > working assumption. On ambiguity: state assumption + confidence, invite override, continue — never stall. Echo the resolved profile to the user. Detail: `references/platform-profiles.md`.
4. `## Step 2 — Context Interpreter` — DesignContext fields block (verbatim): productType, domain, targetUsers, primaryJobs, currentScreen, informationDensity (low|medium|high), designMaturity (concept|existing-product|redesign), existingDesignSystem, constraints, noveltyLevel (conventional|balanced|experimental). Sources: request + repo scan (tokens, navigation, components, stack) + project memory. Missing fields → explicit assumptions.
5. `## Step 3 — Mode` — one-line table of the six modes (explore / grounded / hybrid default / audit / prototype / cross-platform-synthesis) → detail in `references/modes.md`.
6. `## Step 4 — Research` — build axes+rings per `references/research-method.md`; dispatch `design-scout` agent: 1 `quick` scout for point questions, 2–3 parallel `survey` scouts (split by ring or axis) for broad research; cross-platform-synthesis mode dispatches separate scouts per platform. Free sources only. Thin/failed research → fallback protocol in research-method.md.
7. `## Step 5 — Evaluate & synthesize` — score with the 7 dimensions/weights, build pattern matrix, anti-patterns, 2–3 directions (safe/balanced/experimental), decision record; provenance label on every key decision.
8. `## Step 6 — Generate (routing table)` — table: mobile → mobile-design-patterns build mode + ersatz-design with research_summary; web → web-platform.md constraints + ersatz-design (+ hallmark/frontend-design/coss); Figma → figma skills; RN code → expo skills + project conventions.
9. `## Step 7 — Verify` — run `references/verification.md` (shared + platform checklist); mobile results additionally through mobile-design-patterns audit mode.
10. `## Output scaling` — point question → recommendation + spec; broad research → framing + reference map + matrix + directions + decision record; formats in `references/output-formats.md`.

- [x] **Step 2: Verify**

Run: `test -f /Users/dmitromusijcenko/.claude/skills/design-agent/SKILL.md && grep -c "MODEL-KNOWLEDGE\|Platform Router\|research_summary\|design-scout" /Users/dmitromusijcenko/.claude/skills/design-agent/SKILL.md && wc -l < /Users/dmitromusijcenko/.claude/skills/design-agent/SKILL.md`
Expected: grep count ≥ 4; line count ≤ ~210.

### Task 2: `references/modes.md`

**Files:**
- Create: `/Users/dmitromusijcenko/.claude/skills/design-agent/references/modes.md`

**Interfaces:**
- Consumes: mode names from Task 1.
- Produces: per-mode protocol; the four-bucket cross-platform output names used by Task 6 (`Stays shared` / `Adapts for mobile` / `Adapts for web` / `Must not transfer literally`).

- [x] **Step 1: Write modes.md** — `# Modes` intro (1 line: mode chosen at Step 3; user-named mode wins; otherwise inferred and stated). Then one H2 per mode, each with `Goal / Ring emphasis / Evidence bar / Output set / Labeling`:
  - `## explore` — little specificity given; agent widens; rings 1–4 emphasis; 3–5 strongly divergent concepts; adjacent industries allowed; every non-evidenced idea labeled `SPECULATION` with the note "not found as a shipped pattern — agent synthesis"; output: framing + directions.
  - `## grounded` — maximum precision; rings 0–3 only; only found implementations; every decision shows origin + dateChecked + alternatives + limitations; Tier D may inform aesthetics only, never interaction; no pattern proposed without evidence; output: framing + reference map + matrix + decision record.
  - `## hybrid` — default; ~70–80% decisions evidence-based (SOURCE/SYNTHESIS), 20–30% labeled SPECULATION; output scales to ask.
  - `## audit` — inputs: screenshots / Figma / UI code / existing DS. Sequence: resolve platform+context → run platform checklist (mobile-design-patterns audit mode, or web checklist in verification.md) → dispatch scout to compare against real implementations of the same task → findings with the severity taxonomy + rule-type check → fix order. Real problems separated from taste (`Subjective preference` severity exists for that).
  - `## prototype` — requires an approved direction (from a prior mode or explicit user choice). Produces: screen structure, component inventory, token map, states inventory, motion, gestures/interaction spec, a11y constraints, acceptance criteria → routes to builder skills → ends with verification.md run (+ audit for mobile).
  - `## cross-platform-synthesis` — its own process, NOT two profiles merged. Separate scouts per platform; then split explicitly: shared product model / shared terminology / shared design tokens & visual DNA vs platform-specific navigation, interaction behavior, information density, components. Output = four buckets verbatim: `Stays shared`, `Adapts for mobile`, `Adapts for web`, `Must not transfer literally`.

- [x] **Step 2: Verify**

Run: `grep -c "cross-platform-synthesis\|Must not transfer literally\|SPECULATION" /Users/dmitromusijcenko/.claude/skills/design-agent/references/modes.md`
Expected: ≥ 3.

### Task 3: `references/research-method.md`

**Files:**
- Create: `/Users/dmitromusijcenko/.claude/skills/design-agent/references/research-method.md`

**Interfaces:**
- Consumes: ring/tier/scoring vocabulary (Global Constraints).
- Produces: the method design-scout condenses (Task 9 embeds a short copy + sync note both ways); fallback protocol referenced by Tasks 1, 8, 9.

- [x] **Step 1: Write research-method.md** with H2 sections:
  1. `## Search axes` — product / task / platform / interaction / state / visual direction / audience, with the mental-health example axes from the spec's lineage (Product: mental health assistant; Task: start daily reflection; Platform: iOS mobile; Interaction: conversational onboarding; State: first session; Visual: calm editorial; Audience: returning users).
  2. `## Rings` — Ring 0 exact match; Ring 1 adjacent products same task; Ring 2 same interaction pattern in other domains; Ring 3 official design systems & standards (HIG, Material 3, Fluent, Carbon, Atlassian, WCAG 2.2, WAI-ARIA APG); Ring 4 experimental (editorial, fashion, games, automotive, concept UI, motion) — inspiration only, never usability evidence. 3 example queries per ring using the axes example.
  3. `## Widen when` — <5–7 truly relevant results; visual monotony; only one solution shape found; single-product results; no full flows; only pretty screens without states (keyboard/loading/error/empty/long-content).
  4. `## Narrow when` — mobile/desktop mixing; consumer/enterprise mixing; different user task behind similar visuals; different IA behind similar visuals; concept shots instead of shipped products; platform or input mismatch; stale results in a fast-moving category.
  5. `## Source tiers` — A normative (Apple HIG, Material 3, Fluent, WCAG 2.2, WAI-ARIA APG, official DS); B real shipped products via free libraries (vp0.com, banani.co, pageflows.com, uisources.com, mobbin.com free tier) — screens, full flows, states, gestures, onboarding, errors, paywalls; C usability studies / HCI papers / public redesign case studies; D Dribbble/Behance/Awwwards/Pinterest — sets art direction only. Rule verbatim: "Tier D never proves usability. Grounded recommendations require Tier A or B evidence."
  6. `## Scoring` — table of 7 dimensions, 0–5 each, rank weights 25/20/15/15/10/10/5; rule verbatim: "A beautiful screen solving the wrong task loses to a plainer but task-exact flow."
  7. `## Freshness` — dateChecked mandatory; freshnessRelevance = how much recency matters for this category (fast-moving consumer UI vs stable enterprise patterns).
  8. `## Fallback protocol (no/thin live research)` — numbered, verbatim from spec §10: (1) state explicitly that live research was not performed / incomplete and why; (2) never present internal knowledge as live results — no fabricated sources, links, or dates; (3) lower stated confidence; (4) label affected content `MODEL-KNOWLEDGE` instead of `SOURCE`; (5) list what must be verified later.
  9. Sync note at top: "Condensed copy lives inside `~/.claude/agents/design-scout.md` — keep both in sync when editing."

- [x] **Step 2: Verify**

Run: `grep -c "Ring 0\|Ring 4\|Tier D never proves usability\|Fallback protocol\|MODEL-KNOWLEDGE" /Users/dmitromusijcenko/.claude/skills/design-agent/references/research-method.md`
Expected: ≥ 5.

### Task 4: `references/platform-profiles.md`

**Files:**
- Create: `/Users/dmitromusijcenko/.claude/skills/design-agent/references/platform-profiles.md`

**Interfaces:**
- Consumes: Router fields from Task 1.
- Produces: PlatformProfile schema; source routing table used by scout prompts; cross-platform mapping table used by cross-platform-synthesis mode.

- [x] **Step 1: Write platform-profiles.md** with sections:
  1. `## Router procedure` — restate: mandatory first stage, before research and any design skill; resolution priority (user-stated > detected > assumption+confidence+override invitation); never stall; hard rule "mobile and web references are never mixed unless cross-platform-synthesis mode is active"; detection signals table (RN/Expo code→cross-platform-mobile; SwiftUI→ios; Jetpack Compose→android; Next.js/Tailwind→responsive-web or desktop-web by density; ~390px Figma frames→mobile; ≥1200px frames→desktop-web; browser-nav mentions→web).
  2. `## PlatformProfile schema` — fenced block, verbatim fields: family, target, primary, secondary, formFactor, inputMethods, navigationEnvironment (native-stack | browser-history | tabs | sidebar | multi-window), screenClasses, systemConstraints, platformSources, implementation {framework, styling, componentLibrary}, confidence, assumptions.
  3. `## Example: cross-platform mobile (RN/Expo)` — filled profile: family mobile; target cross-platform-mobile; primary ios; secondary android; inputMethods touch+keyboard; navigationEnvironment native-stack+tabs; systemConstraints safe-area, software-keyboard, ios-back-gesture, android-system-back, reduced-motion; platformSources Apple HIG + Material 3 + RN platform behavior.
  4. `## Example: responsive web (Next.js + Tailwind)` — filled profile: family web; target responsive-web; inputMethods mouse+trackpad+keyboard+touch; navigationEnvironment browser-history; screenClasses mobile/tablet/desktop/wide-desktop; systemConstraints responsive-reflow, keyboard-navigation, semantic-html, browser-zoom-200, reduced-motion, deep-linking; platformSources WCAG 2.2 + WAI-ARIA APG + relevant web design systems.
  5. `## Source routing` — table: ios→Apple HIG + product refs; android→Material 3 + OEM/product refs; web→WCAG 2.2 + WAI-ARIA APG + relevant web DS; enterprise→Carbon/Fluent/Atlassian; Shopify-embedded→Polaris; existing internal DS→internal system FIRST, always.
  6. `## Cross-platform mapping` — table with columns Part / Mobile / Web, rows verbatim from spec lineage: primary navigation (tab bar+stack vs sidebar/top nav); contextual actions (bottom sheet vs popover/dropdown); primary action (footer/FAB/composer vs toolbar/inline); drag-and-drop (secondary vs primary); hover (absent vs used); keyboard shortcuts (minimal vs full system); data density (lower vs higher); multi-panel (rare vs common); modality (sheet/fullscreen vs dialog/drawer); back behavior (system gesture vs browser history). Closing rule verbatim: "Transfer the principle, not the literal implementation."

- [x] **Step 2: Verify**

Run: `grep -c "PlatformProfile\|cross-platform-synthesis\|Transfer the principle" /Users/dmitromusijcenko/.claude/skills/design-agent/references/platform-profiles.md`
Expected: ≥ 3.

### Task 5: `references/web-platform.md`

**Files:**
- Create: `/Users/dmitromusijcenko/.claude/skills/design-agent/references/web-platform.md`

**Interfaces:**
- Consumes: platform targets vocabulary.
- Produces: the v1 web knowledge module loaded for any web-family task; component-pattern names used by web verification (Task 7).

- [x] **Step 1: Write web-platform.md** — header note: "v1 basic web module — assesses platform applicability; does not drive the workflow (design-agent does). Extended web-design-patterns skill is a planned follow-up." Sections:
  1. `## Web contexts` — responsive web / desktop web application / mobile web: density, chrome, and navigation-model differences; one paragraph each.
  2. `## Browser environment` — history & URL-as-state (refresh survives, deep links work, back button semantics never break); state that belongs in the URL: route, selected entity, filters, tab; state that does not: transient UI.
  3. `## Responsive reflow` — breakpoints as content-driven, container strategy, content priority on narrow viewports, zoom to 200% without loss (WCAG 1.4.10 reflow).
  4. `## Input methods` — mouse, trackpad, keyboard, touch coexisting; hover never the only path to a function (touch parity); pointer-target sizes on touch-capable web.
  5. `## Interactive states` — hover, focus, active, disabled, loading required for every interactive element; visible focus (WCAG 2.4.7); skeletons/spinners for region-level loading.
  6. `## Semantics & accessibility` — semantic HTML first (native elements before ARIA); keyboard navigation end-to-end; focus management (dialogs trap and restore, route changes move focus); WCAG 2.2 + WAI-ARIA APG as routing targets for verifiable requirements — link the APG pattern index.
  7. `## Component patterns` — one short block each with "fits when / APG or DS pointer": dialogs (modal decisions), popovers (light contextual), dropdowns/menus, sidebars (top-level nav for app-like products), toolbars (persistent document/editor actions), tables (density + sorting/selection; degrade to cards on narrow), multi-panel layouts (list-detail, three-pane; collapse order on narrow).

- [x] **Step 2: Verify**

Run: `grep -c "URL-as-state\|focus management\|WAI-ARIA APG\|multi-panel" /Users/dmitromusijcenko/.claude/skills/design-agent/references/web-platform.md`
Expected: ≥ 4.

### Task 6: `references/output-formats.md`

**Files:**
- Create: `/Users/dmitromusijcenko/.claude/skills/design-agent/references/output-formats.md`

**Interfaces:**
- Consumes: evidence contract fields (Global Constraints + Task 9 contract), four-bucket names from Task 2.
- Produces: the 8 numbered format templates + scaling table used by Task 1 step 10.

- [x] **Step 1: Write output-formats.md** — 8 H2 sections, each a fenced template with field placeholders, plus a scaling table:
  1. `## 1 Research framing` — what was researched / constraints used / directions excluded / how wide the search went / mode + rings used.
  2. `## 2 Reference map` — per reference, the full evidence contract fields (title, source, sourceType, platform, productDomain, userTask, interactionPattern, dateChecked, freshnessRelevance, taskFit, platformFit, transferablePrinciples, limitations, doNotCopyDirectly, confidence, provenance) + "What to take / What NOT to transfer / Why it fits us".
  3. `## 3 Pattern matrix` — markdown table: Task | Option A | Option B | Option C | Recommendation.
  4. `## 4 Anti-patterns` — concrete risks with reasons tied to THIS product ("Do not use X here because Y"), never generic advice.
  5. `## 5 Design directions` — 2–3: safe/platform-familiar, balanced, experimental; each with what it optimizes and its risk.
  6. `## 6 Decision record` — decision / alternatives considered / why rejected / sources / confidence / what still needs validation.
  7. `## 7 Prototype specification` — screen structure, component inventory, states inventory, token map, motion, gestures/interaction, responsive-adaptive behavior, accessibility, acceptance criteria.
  8. `## 8 Cross-platform split` — the four buckets verbatim: Stays shared / Adapts for mobile / Adapts for web / Must not transfer literally.
  9. `## Scaling` — table: point question → formats none (inline recommendation + spec + sources); focused research → 1+2+6; broad research → 1+2+3+4+5+6; audit → findings report (mobile-design-patterns / web checklist format) + 4+6; prototype → 7 (+6); cross-platform-synthesis → 1+2+8+6. Rule: never dump all 8 for small asks.

- [x] **Step 2: Verify**

Run: `grep -c "## 8 Cross-platform split\|doNotCopyDirectly\|Scaling" /Users/dmitromusijcenko/.claude/skills/design-agent/references/output-formats.md`
Expected: ≥ 3.

### Task 7: `references/verification.md`

**Files:**
- Create: `/Users/dmitromusijcenko/.claude/skills/design-agent/references/verification.md`

**Interfaces:**
- Consumes: component-pattern names from Task 5; provenance labels.
- Produces: the design-verifier checklists run at workflow Step 7.

- [x] **Step 1: Write verification.md** — header boundary note: "Runs AFTER synthesis or prototyping — never before. Checks the result against brief, research, platform profile, and design system." Three H2 sections:
  1. `## Shared checklist` — brief match; internal consistency; hierarchy works; tokens used (no magic values); states coverage (empty/loading/error/keyboard/long-content); navigation integrity; provenance labels present on key decisions; divergence from chosen references is justified in the decision record; AI-slop scan (purple-gradient hero, generic 3-card feature rows, emoji section headers, evenly-weighted everything, decorative glassmorphism without register) — for web aesthetics also defer to hallmark when it runs.
  2. `## Mobile` — one line: run `mobile-design-patterns` audit mode on the produced result; findings use its severity taxonomy.
  3. `## Web checklist` — URL/history state correct (refresh + deep link + back safe); keyboard operability end-to-end; visible focus states; managed focus order (dialogs trap and restore); semantic landmarks and heading structure; hover-independent functionality (touch parity); responsive reflow at key widths and 200% zoom; hover/focus/active/disabled/loading present on every interactive element; reduced-motion respected; tables and multi-panel layouts degrade on narrow viewports.

- [x] **Step 2: Verify**

Run: `grep -c "AFTER synthesis\|Web checklist\|trap and restore\|200% zoom" /Users/dmitromusijcenko/.claude/skills/design-agent/references/verification.md`
Expected: ≥ 4.

### Task 8: `README.md` (user-facing)

**Files:**
- Create: `/Users/dmitromusijcenko/.claude/skills/design-agent/README.md`

**Interfaces:**
- Consumes: everything from Tasks 1–7 (must describe only implemented behavior).

- [x] **Step 1: Write README.md** — sections: What this is (3 lines); How to ask (recommended format: task + platform if known + mode if desired + constraints; note that platform/mode are auto-detected and echoed back, and the user can override the detected platform in one line); Modes table (6 rows, one line each); Good asks vs bad asks (3 good examples: "найди как живые приложения делают историю чатов, iOS", "explore: направления для onboarding, можно смело", "audit: вот скриншоты, проверь против реальных реализаций"; 2 bad: "сделай красиво" without any subject, asking ersatz-design directly for a full screen without research); Labels section — SOURCE / SYNTHESIS / SPECULATION / MODEL-KNOWLEDGE explained in one line each; Routing section — mobile / web / cross-platform in one paragraph incl. the four-bucket cross-platform output; Limitations (verbatim list): free sources only (no Refero/Mobbin integrations), web module is basic v1 (extended web skill planned), no domain knowledge files yet, research quality depends on live web access — when unavailable the agent says so and labels output MODEL-KNOWLEDGE.

- [x] **Step 2: Verify**

Run: `grep -c "MODEL-KNOWLEDGE\|Limitations\|cross-platform" /Users/dmitromusijcenko/.claude/skills/design-agent/README.md`
Expected: ≥ 3.

### Task 9: `design-scout` v2 (backup + rewrite)

**Files:**
- Create: `/Users/dmitromusijcenko/.claude/agents/design-scout.md.bak` (copy of current file)
- Modify: `/Users/dmitromusijcenko/.claude/agents/design-scout.md` (full rewrite)

**Interfaces:**
- Consumes: method from Task 3 (condensed), evidence contract (below), source routing from Task 4.
- Produces: dispatch contract for Task 1 Step 4 — prompt keywords `mode: quick` / `mode: survey`; output shapes below.

- [x] **Step 1: Backup**

Run: `cp /Users/dmitromusijcenko/.claude/agents/design-scout.md /Users/dmitromusijcenko/.claude/agents/design-scout.md.bak && ls -la /Users/dmitromusijcenko/.claude/agents/`
Expected: both files listed.

- [x] **Step 2: Rewrite design-scout.md** with frontmatter (keep tools + model from v1):

```markdown
---
name: design-scout
description: Design reference researcher with two modes. quick — точечный вопрос, одна рекомендация со спекой и источниками; survey — карта референсов с полными метаданными и оценками для design-agent. Ищет как реально делают в живых приложениях и официальных гайдлайнах (поиск реффов, "как это делают", "какой паттерн"), бесплатные источники. Research only: расширяет/сужает поиск и возвращает evidence package — финальное дизайн-решение принимает вызывающий (design-agent).
tools: WebSearch, WebFetch, Read, Grep, Glob, mcp__Claude_Browser__preview_start, mcp__Claude_Browser__navigate, mcp__Claude_Browser__get_page_text, mcp__Claude_Browser__read_page, mcp__Claude_Browser__computer, mcp__Claude_Browser__tabs_create, mcp__Claude_Browser__tabs_context, mcp__Claude_Browser__resize_window
model: sonnet
---
```

Body (English), sections:
1. Role: design reference researcher. Boundary verbatim: "You research, widen and narrow the search space, and return an evidence package. You never make the final design decision — the dispatcher (design-agent or the user) does. You never edit project files."
2. `## Modes` — `quick` (default when the task is a point question): output exactly these H2 sections — Recommendation (one pattern, one paragraph) / Why (2–4 evidence-backed bullets) / Specification (concrete numbers: sizes, spacing, radii, snap points, timings, gestures, dark-theme behavior; cite project tokens by name if they exist) / Rejected alternatives (one line + reason each) / Sources (each with the evidence contract). `survey` (when dispatched with rings/axes): output — Research framing (what was searched, what was excluded, rings covered) / References (each with the FULL evidence contract) / Gaps (missing states, missing flows, monotony) / Widen-or-narrow recommendation.
3. `## Evidence contract` — fenced block, verbatim:

```
title | source (link) | sourceType | platform | productDomain | userTask |
interactionPattern | dateChecked | freshnessRelevance | taskFit 0–5 |
platformFit 0–5 | transferablePrinciples | limitations | doNotCopyDirectly |
confidence | provenance (SOURCE / SYNTHESIS / SPECULATION / MODEL-KNOWLEDGE)

sourceType: official-guideline | official-design-system | real-shipped-product |
case-study-or-research | concept-or-visual-inspiration
```

   Rule verbatim: "A popular concept shot is never evidence of usability — concepts inform aesthetics only, and you must say so when citing one."
4. `## Method (condensed)` — rings 0–4 one line each; tiers A–D one line each incl. "Tier D never proves usability"; widen/narrow trigger lists (short); scoring dimensions + weights one line; context-first rule from v1 (read project tokens `src/design/*`, components, docs/handoffs before searching; ground in the existing system). Sync note: "Full method: `~/.claude/skills/design-agent/references/research-method.md` — keep in sync."
5. `## Rules` — free sources only (open sites + free tiers of vp0.com, banani.co, pageflows.com, uisources.com, mobbin.com; no paid services); numbers mandatory; never mix platforms — every reference tagged; both iOS and Android when the project targets both, divergences shown explicitly; describe screenshots in words; answer in the conversation language; freshness — record dateChecked honestly.
6. `## Fallback` — verbatim: "If search tools fail or results are thin: say so explicitly; never present internal knowledge as live results; no fabricated sources, links, or dates; lower confidence; label such content MODEL-KNOWLEDGE; list what needs later verification."

- [x] **Step 3: Verify**

Run: `grep -c "quick\|survey\|doNotCopyDirectly\|MODEL-KNOWLEDGE\|never make the final design decision" /Users/dmitromusijcenko/.claude/agents/design-scout.md && test -f /Users/dmitromusijcenko/.claude/agents/design-scout.md.bak && echo BAK-OK`
Expected: grep ≥ 5; `BAK-OK`.

### Task 10: `mobile-design-patterns` v2 fork

**Files:**
- Create: `/Users/dmitromusijcenko/.claude/skills/mobile-design-patterns/SKILL.md`
- Create: `/Users/dmitromusijcenko/.claude/skills/mobile-design-patterns/references/audit-checklist.md`
- Create: `/Users/dmitromusijcenko/.claude/skills/mobile-design-patterns/references/examples/notely-ios-dark-reference.md`
- Create: `/Users/dmitromusijcenko/.claude/skills/mobile-design-patterns/references/platforms/ios.md`
- Create: `/Users/dmitromusijcenko/.claude/skills/mobile-design-patterns/references/platforms/android.md`
- Source material: read the synced originals at `/Users/dmitromusijcenko/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin/f510665f-a083-4216-b184-953d1de3e611/9b602862-8811-4635-a215-6d6a3a8a7302/skills/mobile-design-patterns/` (SKILL.md, references/reference-values.md, references/audit-checklist.md).

**Interfaces:**
- Consumes: severity taxonomy + rule types (Global Constraints).
- Produces: audit mode invoked by verification (Task 7) and audit mode (Task 2); build mode invoked by generation routing (Task 1 Step 6).

- [x] **Step 1: Write SKILL.md** — frontmatter: name `mobile-design-patterns`; description = original's triggers (keep RU+EN phrases) + append "(local v2 — supersedes the anthropic-skills copy; contextual rules, not absolutes)". Body:
  1. Header reframe: "Rules here are contextual heuristics, not laws. Before flagging or applying any rule, classify it: platform rule / usability heuristic / product convention / visual preference — and check the app's context (domain, audience, platform, density needs)." Boundary: "This skill assesses mobile applicability and audits/builds screens. It does not drive the full design workflow — design-agent does; for full redesigns start there."
  2. `## Strong defaults (evidence-backed)` — rewritten from originals in compact contextual format `Prefer / Scope / When it applies / Alternatives / Evidence / Confidence / Exceptions`, covering: tap targets ≥44px (platform rule, HIG/M3, high confidence); keyboard as a layout state (~300–336px on iPhone; usability heuristic, high); one scroll direction per section (usability heuristic, high; exception: pro/data-dense tools); type not smaller than desktop, body ≥16, floor 10 (platform rule iOS 17px base, high); empty states two kinds — first-run vs no-results (usability heuristic, high); bottom sheet for in-context picks (platform rule iOS/Android sheets, high); back affordance on every non-root screen incl. system back on Android (platform rule, high); tab bar = navigation between top-level peer destinations, NOT an action container (platform rule per Apple HIG Tab bars, high).
  3. `## Candidate patterns (apply conditionally — NOT defaults)` — each with `When it fits / When it does not / Evidence / Confidence`: floating pill + detached FAB (fits: 3–4 peer destinations + one dominant create action, consumer apps; doesn't: action depends on context, pro tools; confidence medium); nav-as-homepage (fits: >5 peer destinations, browsing products); swipe-up-for-search (fits: search is THE power action and gesture gets onboarded; confidence low — product convention from Slack/iOS, not a standard); cards as grouping (fits: heterogeneous blocks; doesn't: text-first reading surfaces — whitespace grouping also valid; confidence medium); one-screen-one-job (strong tendency, but dashboards/browsing hubs legitimately compose; confidence medium); long-press peek/menu (fits: content collections; needs discoverability hint).
  4. `## Audit mode` — inputs (Figma via MCP with real node numbers, screenshots, RN/Flutter/SwiftUI/Compose code); process: inventory + context → run references/audit-checklist.md → classify every finding by rule type → report format from the original (Context / Summary / Findings / What's already good / Suggested fix order) but Findings use the NEW severity taxonomy verbatim: `Standard violation` / `Platform convention conflict` / `Usability risk` / `Design-system inconsistency` / `Visual polish` / `Subjective preference`. Rule: stylistic opinions can never be ranked above Visual polish; every finding cites a number or element + the rule type it violates.
  5. `## Build mode` — ordered steps from the original (nav model → screen inventory → per-screen layout → states → motion/gestures) with step 6 replaced verbatim: "Apply the project's design system first. If none exists, you may borrow from references/examples/notely-ios-dark-reference.md as inspiration — always stating it is one example product, not a standard."
  6. `## Platform notes` — pointers to references/platforms/ios.md and references/platforms/android.md.
  7. `## Verification` — the original self-check list, updated to the new taxonomy.

- [x] **Step 2: Write references/examples/notely-ios-dark-reference.md** — copy the original reference-values.md content verbatim, then: retitle to `# Example: Notely (dark-theme iOS notes app) — measured values`; prepend disclaimer verbatim: "This is ONE reference product measured from real frames — an example of a coherent, self-consistent system. These are NOT universal reference values. Use as inspiration or fallback when the project has no design system; never cite as a standard in audits."

- [x] **Step 3: Write references/audit-checklist.md** — port the original checklist items, re-tagging each item's bracket severity to the new taxonomy (44px items → `[Usability risk]`; nav-count and back-affordance items → `[Platform convention conflict]`; type-size items → `[Platform convention conflict]` on iOS body-size, `[Usability risk]` for <10px; token/magic-number items → `[Design-system inconsistency]`; spacing-grid and radius consistency → `[Visual polish]`; four-blocks composition → `[Subjective preference]`), and adding a `Rule type` note per section header (Navigation → platform rule; Typography → platform rule/usability; Layout → usability heuristic; Structure → product convention; States → usability heuristic; Code-specific → design-system).
- [x] **Step 4: Write references/platforms/ios.md** (≤80 lines) — sheets (detents, grabber, when sheet vs push), edge-swipe back + parallax, safe areas (Dynamic Island, home indicator), HIG type (17px body, Dynamic Type), 44pt targets, SF Symbols sizing, haptics conventions, link to developer.apple.com/design/human-interface-guidelines.
- [x] **Step 5: Write references/platforms/android.md** (≤80 lines) — system back + predictive back (must not be swallowed), edge-to-edge insets, M3 navigation bar/rail conventions, 48dp targets, keyboard (IME) insets behavior, dynamic color note, link to m3.material.io. Include the RN pitfall notes relevant to both files' topics from user memory (edge-to-edge tap swallowing; formSheet/ScrollView) as one-line "RN quirks" bullets.

- [x] **Step 6: Verify**

Run: `grep -c "Subjective preference\|Candidate patterns\|local v2" /Users/dmitromusijcenko/.claude/skills/mobile-design-patterns/SKILL.md && grep -c "NOT universal" /Users/dmitromusijcenko/.claude/skills/mobile-design-patterns/references/examples/notely-ios-dark-reference.md && ls /Users/dmitromusijcenko/.claude/skills/mobile-design-patterns/references/platforms/`
Expected: SKILL greps ≥ 3; disclaimer present; ios.md + android.md listed.

### Task 11: `ersatz-design` v2 fork

**Files:**
- Create: `/Users/dmitromusijcenko/.claude/skills/ersatz-design/SKILL.md`
- Source material: read the synced original at `/Users/dmitromusijcenko/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin/f510665f-a083-4216-b184-953d1de3e611/9b602862-8811-4635-a215-6d6a3a8a7302/skills/ersatz-design/SKILL.md`.

**Interfaces:**
- Consumes: research_summary shape (context, approved AND rejected pattern decisions, visual references, platform constraints, existing tokens, novelty level) produced by design-agent Step 5.
- Produces: visual synthesis + code, consumed by generation routing (Task 1 Step 6).

- [x] **Step 1: Write SKILL.md** — frontmatter: name `ersatz-design`; description rewritten: "Visual synthesis engine (local v2 — supersedes the anthropic-skills copy). Normally invoked BY design-agent after research, with a research_summary. Direct use is for quick isolated components only — and then it must label its decisions SPECULATION. Triggers: generating UI when evidence already exists ('сделай по этим реффам', 'generate from the research summary'), or explicitly speculative quick components." Body = the original's step structure, reworked:
  1. `## Required input — research_summary` — fenced block listing: context (DesignContext), approvedPatterns, rejectedPatterns, visualReferences, platformConstraints, existingTokens, noveltyLevel. Gate verbatim: "Without a research_summary you may proceed ONLY in explicitly labeled SPECULATION mode: state 'No research input — running as SPECULATION' in the rationale, and never silently design from a blank slate."
  2. `## Provenance` — every key decision (accent strategy, hierarchy, composition, palette, type) labeled `SOURCE` (seen in a provided reference) / `SYNTHESIS` (combined from several) / `SPECULATION` (new experimental).
  3. `## Separation of concerns` — output distinguishes: visual direction / interaction architecture / design system (tokens) / implementation. Interaction architecture comes from the approved patterns — this skill styles it, it does not re-decide it (boundary from spec §5).
  4. Steps 2–6 of the original kept with edits: accent rule replaced verbatim with "Prefer a dominant accent strategy. Multiple accents require explicit semantic or structural justification."; the mood→hex table REMOVED, replaced by derivation order verbatim: "Accent derivation: 1) brand/existing tokens; 2) visual references from the research_summary; 3) only then taste — and that choice is labeled SPECULATION. No fixed mood-to-color mappings."; type scale + spacing tables kept but each introduced with "Defaults, not laws — the project design system and reference evidence override these."; temporal/atemporal kept, reframed "a lens for reading a screen, not a binary classification".
  5. `## Pre-codegen gate` — before writing any code, all present: states inventory (default/hover/focus/active/disabled/loading/empty/error where applicable), component inventory, token map, interaction spec, a11y constraints. If any is missing — produce it first.
  6. `## Generate` + `## After generating` — from the original (complete code, no placeholders; stack priority React+TS+Tailwind / plain HTML / match user stack; rationale format), rationale extended to include provenance labels per decision.
  7. Design-decision rules section from the original kept, minus the mood-color mappings ("more premium/minimal/color" guidance stays — it is style-neutral).

- [x] **Step 2: Verify**

Run: `grep -c "research_summary\|SPECULATION\|dominant accent strategy\|Defaults, not laws\|Pre-codegen" /Users/dmitromusijcenko/.claude/skills/ersatz-design/SKILL.md && grep -c "0015FF" /Users/dmitromusijcenko/.claude/skills/ersatz-design/SKILL.md || true`
Expected: first grep ≥ 5; second grep 0 (mood-hex table gone).

### Task 12: Structural acceptance sweep

**Files:** none created; verification only.

- [x] **Step 1: Full file inventory**

Run: `ls /Users/dmitromusijcenko/.claude/skills/design-agent /Users/dmitromusijcenko/.claude/skills/design-agent/references /Users/dmitromusijcenko/.claude/skills/mobile-design-patterns/references/examples /Users/dmitromusijcenko/.claude/skills/mobile-design-patterns/references/platforms /Users/dmitromusijcenko/.claude/skills/ersatz-design && ls /Users/dmitromusijcenko/.claude/agents/design-scout.md /Users/dmitromusijcenko/.claude/agents/design-scout.md.bak`
Expected: SKILL.md+README.md+6 reference files; notely example; ios.md+android.md; ersatz SKILL.md; scout + .bak.

- [x] **Step 2: Frontmatter validity** — every SKILL.md starts with `---`, has `name:` and `description:`; agent file also `tools:` and `model:`.

Run: `for f in /Users/dmitromusijcenko/.claude/skills/design-agent/SKILL.md /Users/dmitromusijcenko/.claude/skills/mobile-design-patterns/SKILL.md /Users/dmitromusijcenko/.claude/skills/ersatz-design/SKILL.md /Users/dmitromusijcenko/.claude/agents/design-scout.md; do head -1 "$f" | grep -q '^---$' && grep -q '^name:' "$f" && echo "OK $f" || echo "FAIL $f"; done`
Expected: 4 × OK.

- [x] **Step 3: Cross-reference paths resolve** — every `references/...` path mentioned in design-agent SKILL.md exists.

Run: `cd /Users/dmitromusijcenko/.claude/skills/design-agent && grep -o 'references/[a-z-]*\.md' SKILL.md | sort -u | while read p; do test -f "$p" && echo "OK $p" || echo "MISSING $p"; done`
Expected: all OK, no MISSING.

- [x] **Step 4: Vocabulary consistency** — the four provenance labels and six severity strings appear where owned.

Run: `grep -l "MODEL-KNOWLEDGE" /Users/dmitromusijcenko/.claude/skills/design-agent/SKILL.md /Users/dmitromusijcenko/.claude/skills/design-agent/references/research-method.md /Users/dmitromusijcenko/.claude/skills/design-agent/README.md /Users/dmitromusijcenko/.claude/agents/design-scout.md`
Expected: all four files listed.

### Task 13: Behavioral smoke tests

**Files:** none; uses the Agent tool.

- [x] **Step 1: quick-mode smoke test** — dispatch `design-scout` (Agent tool, subagent_type design-scout) with: "mode: quick. Project context: none (greenfield). Question: current pattern for a pull-to-refresh indicator on an iOS chat history list. Keep it small: 2 searches max, 2 sources." Check the reply has the five quick sections (Recommendation / Why / Specification / Rejected alternatives / Sources) and each source carries sourceType + dateChecked + provenance.
- [x] **Step 2: fallback smoke test (acceptance F)** — dispatch `design-scout` with: "mode: survey. Constraint for this dry run: do NOT use WebSearch/WebFetch or the browser — behave as if live research is unavailable, and follow your fallback protocol. Topic: navigation models for a habit tracker, cross-platform-mobile, Ring 0–1 only." Check the reply: states research was not performed, labels content MODEL-KNOWLEDGE, lowers confidence, lists verify-later items, cites zero fabricated links.
- [x] **Step 3: Fix anything the smoke tests expose** — edit the failing file(s), re-run the failed dispatch once.
- [x] **Step 4: Commit plan checkboxes + report** — mark plan checkboxes done; commit the updated plan file in the test-app repo:

```bash
git add docs/superpowers/plans/2026-07-27-design-intelligence-agent.md && git commit -m "Complete design intelligence agent implementation plan execution" --no-verify
```

**Deferred to follow-ups (do NOT implement now):** extended web-design-patterns skill; Refero/Mobbin MCP; domains/*.md; .skill zips for claude.ai re-upload. Acceptance scenarios A–E from spec §16 are full working sessions — run them as the first real usage sessions, not as part of this build (F is covered by Task 13 Step 2).
