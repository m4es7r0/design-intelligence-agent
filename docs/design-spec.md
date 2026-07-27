# Design Intelligence Agent — Design Spec

Date: 2026-07-27
Status: approved with user revisions applied; green-lit for writing-plans and implementation.

## 1. Goal

Build a design intelligence system for Claude Code that grounds design work in live research
instead of LLM defaults or stale patterns. It must operate across a spectrum: fully autonomous
exploration ("give me directions, speculation allowed") through strictly evidence-based,
point-precise decisions. It orchestrates the user's existing skills (`ersatz-design`,
`mobile-design-patterns`) instead of replacing them, and routes prototyping to existing
builder skills (expo-*, hallmark, frontend-design, coss, figma).

Core principle (invariant): **generation is never first**. Research and product decisions
precede visual synthesis. `ersatz-design` runs only after a research summary exists, except
in explicitly labeled speculation mode.

The system claims mobile AND web support — therefore v1 ships a real (if basic) web platform
module and web verification, not mobile-only coverage with a web promise.

## 2. Decisions taken

| Decision | Choice |
|---|---|
| Packaging | One orchestrator skill `design-agent` with `references/` modules + one researcher agent + two forked skills. NOT 8 separate skills (trigger pollution, coordination cost). |
| design-scout | Rewritten in place into the full researcher (modes `quick`/`survey`). Old version preserved as `design-scout.md.bak`. |
| Skill forks | `ersatz-design` and `mobile-design-patterns` forked into `~/.claude/skills/` under the same names (claude.ai-synced copies are session-local and not durably editable). Precedent: `coss`, `react-native-best-practices` already exist in both places. |
| Language | Skill/agent bodies in English; trigger phrases in descriptions bilingual (RU+EN). Output language follows the conversation. |
| Sources | Free-only by default (open sites + free tiers). Refero/Mobbin MCP deferred. |
| Web in v1 | Basic but real: `references/web-platform.md` module + web verification checklist. The extended standalone web-design-patterns skill is the deferred part. |
| Scope now | No `domains/*.md`; no separate verifier/evaluator/router skills — those live as reference modules. |

## 3. File map

```
~/.claude/skills/design-agent/
├── SKILL.md                     # orchestrator (target ≤ ~200 lines)
├── README.md                    # user-facing: what it is, how to ask, modes, labels, limits
└── references/
    ├── modes.md                 # protocols for Explore / Grounded / Hybrid / Audit / Prototype / Cross-platform Synthesis
    ├── research-method.md       # search axes, rings 0–4, widen/narrow, tiers A–D, scoring, freshness, no-research fallback
    ├── platform-profiles.md     # Platform Router procedure, PlatformProfile schema, mobile & cross-platform profiles, source routing
    ├── web-platform.md          # v1 web module: contexts, inputs, states, semantics, a11y routing, web component patterns
    ├── output-formats.md        # 8 deliverable formats + scaling rules
    └── verification.md          # shared design QA + provenance audit + web verification checklist

~/.claude/agents/design-scout.md          # rewritten researcher; old file → design-scout.md.bak

~/.claude/skills/mobile-design-patterns/
├── SKILL.md                     # contextual rules rework
└── references/
    ├── audit-checklist.md       # updated severity + rule-type
    ├── examples/notely-ios-dark-reference.md   # former reference-values.md, demoted to a single-product example
    └── platforms/ios.md, platforms/android.md  # lean platform-specific notes

~/.claude/skills/ersatz-design/
└── SKILL.md                     # research-grounded generation rework
```

## 4. Component: `design-agent` orchestrator skill

**Trigger (description):** design research, reference hunting, pattern decisions, full design
cycles, redesigns, prototyping requests. RU+EN phrases: "найди реффы/референсы", "как это
делают", "какой паттерн", "исследуй направления", "спроектируй экран/страницу", "design
research", "find references", "what's the current pattern", "explore directions". States
explicitly that for non-trivial design work it supersedes calling `ersatz-design` /
`mobile-design-patterns` directly.

**Workflow (fixed order):**

1. **Platform Router — mandatory first stage.** Runs before research and before any design
   skill is invoked. Resolves and echoes back:
   - `family`: mobile / web / cross-platform
   - `target`: ios / android / cross-platform-mobile / responsive-web / desktop-web / mobile-web
   - `primary` and `secondary` platform
   - `formFactor` (phone / large-phone / tablet / foldable / desktop / wide-desktop)
   - `inputMethods` (touch / mouse / trackpad / keyboard / stylus)
   - `implementation` stack (framework, styling, component library)
   - `confidence` (high / medium / low) and explicit `assumptions`
   Resolution priority: user-stated > detected from materials (RN code / Next.js / screenshots /
   Figma frame size) > working assumption stated with confidence. On ambiguity: fix a working
   assumption, show confidence, invite the user to override, and continue — never stall.
   Hard rule: mobile and web references are never mixed unless the explicit cross-platform
   mode is active.
2. **Context Interpreter** — build a normalized `DesignContext` from the request + repo scan
   (design tokens, navigation, components, stack) + project memory. Fields: productType,
   domain, targetUsers, primaryJobs, currentScreen, informationDensity, designMaturity,
   existingDesignSystem, constraints, noveltyLevel. Missing fields get explicit assumptions,
   not silence.
3. **Mode selection** — explore / grounded / hybrid (default) / audit / prototype /
   cross-platform synthesis, per `references/modes.md`. User can name a mode; otherwise
   inferred and stated.
4. **Research** — formulate search axes and rings per `references/research-method.md`, then
   dispatch the `design-scout` agent: 1 quick scout for a point question; 2–3 parallel survey
   scouts (split by ring or axis) for broad research. Free sources only. If live research
   fails or comes back thin, apply the fallback protocol (§10).
5. **Evaluate & synthesize** — in the main thread: score references, build the pattern matrix,
   extract anti-patterns, form 2–3 directions (safe / balanced / experimental), write the
   decision record. Every key decision carries a provenance label: SOURCE / SYNTHESIS /
   SPECULATION (or MODEL-KNOWLEDGE under fallback).
6. **Generate** — route by platform and target artifact:
   - mobile UI decisions → `mobile-design-patterns` (build mode) + `ersatz-design` with a
     `research_summary`;
   - web → `web-platform.md` constraints + `ersatz-design` (+ hallmark / frontend-design /
     coss where they fit);
   - Figma deliverable → figma skills; RN code → expo skills + project conventions.
7. **Verify** — run `references/verification.md` (shared + platform-appropriate checklist);
   for mobile output additionally run `mobile-design-patterns` audit mode against the result.

**Invariants (stated in SKILL.md):**
- Platform resolves before everything else; references are never cross-platform-mixed silently.
- `ersatz-design` is never the first step and never runs without a research_summary plus
  approved pattern decisions (except labeled SPECULATION).
- In grounded/hybrid, generation without evidence is forbidden.
- In explore, speculation is allowed but must be labeled.
- Fallback results are never presented as live-verified research.
- Output size scales to the ask (point question → recommendation + spec; full research →
  framing + map + matrix + directions + record). Do not dump all 8 formats for small asks.

## 5. Responsibility boundaries (embedded in each file)

| Component | Owns | Must NOT |
|---|---|---|
| `design-agent` | Single primary user entry point; context; platform routing; mode choice; final decisions; final output assembly | Delegate final decisions to sub-components |
| `design-scout` | Research only: widen/narrow search space, evidence package with full metadata | Make final design decisions; edit files |
| `mobile-design-patterns` / `web-platform.md` | Platform applicability assessment, platform rules and checklists | Drive the full workflow |
| `ersatz-design` | Visual synthesis and prototype direction AFTER research_summary + approved pattern decisions | Start design from a blank slate without an evidence package |
| `verification.md` (design-verifier role) | Post-synthesis check against brief, research, platform profile, design system | Run before synthesis |

## 6. Component: `references/` modules

**modes.md** — per mode: goal, ring emphasis, evidence requirements, output set, labeling rules.
- Explore: rings 1–4 emphasis, 3–5 divergent concepts, speculation allowed + labeled.
- Grounded: rings 0–3, only found implementations, origins + dates + alternatives shown,
  no pattern without evidence; Tier D may inform aesthetics only.
- Hybrid (default): ~70–80% evidence-based, 20–30% labeled synthesis/speculation.
- Audit: inputs (screenshots / Figma / code / DS) → context → usability check via
  mobile-design-patterns or the web checklist → comparison against real implementations
  (scout) → concrete changes; separates real problems from taste.
- Prototype: requires an approved direction; produces screen structure, component inventory,
  tokens, states, motion, a11y, acceptance criteria; routes to builder skills; ends with
  verification of the produced artifact.
- **Cross-platform Synthesis** (its own process, not a merge of two profiles): explicitly
  separates shared product model / shared terminology / shared design tokens & visual DNA
  from platform-specific navigation, interaction behavior, information density, and
  components. Output must show four buckets: stays shared; adapts for mobile; adapts for
  web; must not transfer literally. Research runs per-platform (separate scouts), synthesis
  compares.

**research-method.md** — search axes (product / task / platform / interaction / state / visual
direction / audience); rings 0 exact match, 1 adjacent products same task, 2 same interaction
pattern in other domains, 3 official design systems & standards, 4 experimental references
(inspiration only). Widen when: <5–7 relevant results, visual monotony, single-product
results, no full flows, no states (keyboard/loading/error/empty). Narrow when: platform mixing,
consumer/enterprise mixing, task mismatch, concept-shots-only, stale results in a fast-moving
category. Source tiers: A normative (Apple HIG, Material 3, Fluent, WCAG 2.2, WAI-ARIA APG,
official DS), B real shipped products (free screen libraries: vp0.com, banani.co,
pageflows.com, uisources.com, mobbin free tier), C research/case studies, D concepts & visual
inspiration (Dribbble, Behance, Awwwards) — Tier D never proves usability. Scoring: rate each
candidate 0–5 on taskFit, platformFit, domainFit, evidenceQuality, transferability, freshness,
visualRelevance; rank with weights 25/20/15/15/10/10/5. A beautiful screen solving the wrong
task loses to a plainer but task-exact flow. Includes the no-live-research fallback protocol
(§10).

**platform-profiles.md** — the Platform Router procedure (step 1 fields, resolution priority,
ambiguity handling, override invitation); `PlatformProfile` schema; filled example profiles
for mobile-cross-platform (RN/Expo) and responsive-web (Next.js + Tailwind); source routing
table (iOS→HIG, Android→M3, web→WCAG/APG + relevant web design systems,
enterprise→Carbon/Fluent/Atlassian, internal DS first when present); cross-platform mapping
table (nav, contextual actions, primary action, modality, back behavior, density per
platform). Rule: transfer the principle, not the literal implementation.

**web-platform.md** — the v1 web module. Covers:
- Web contexts: responsive web, desktop web application, mobile web — and how they differ
  (density, chrome, navigation models).
- Browser environment: history and URL-as-state, refresh, deep links, back button semantics.
- Responsive reflow: breakpoints, container strategy, content priority, zoom to 200%.
- Input methods: mouse, trackpad, keyboard, touch — and their coexistence on one page.
- Interactive states: hover, focus, active, disabled, loading — required for every
  interactive element.
- Semantics & accessibility: semantic HTML first, keyboard navigation, focus management,
  WCAG 2.2 + WAI-ARIA APG as the routing targets for verifiable requirements.
- Component patterns: dialogs, popovers, dropdowns, sidebars, toolbars, tables,
  multi-panel layouts — when each fits, with APG pointers.

**output-formats.md** — templates for: 1 research framing, 2 reference map (per reference:
the full evidence contract from §7), 3 pattern matrix (task × options × recommendation),
4 anti-patterns (concrete risks, not platitudes), 5 design directions (2–3:
safe/balanced/experimental), 6 decision record (decision, alternatives, why rejected,
sources, confidence, open questions), 7 prototype specification, 8 cross-platform split
(shared / mobile-adapted / web-adapted / non-transferable). Plus scaling rules: which
formats ship for which ask size/mode.

**verification.md** — three parts:
1. Shared checklist: brief match; consistency; hierarchy; token usage; states coverage;
   navigation integrity; provenance labels present; divergence from chosen references
   justified; scan for stock AI-slop patterns (purple-gradient hero, generic 3-card feature
   rows, emoji section headers).
2. Mobile: run `mobile-design-patterns` audit mode on the result.
3. Web verification checklist: URL/history state correct; keyboard operability end-to-end;
   visible focus states and managed focus order (dialogs trap and restore focus); semantic
   landmarks/headings; hover-independent functionality (touch parity); responsive reflow at
   key widths + 200% zoom; hover/focus/active/disabled/loading present; reduced-motion
   respected; tables and multi-panel layouts degrade on narrow viewports.

## 7. Component: `design-scout` v2 (agent, rewritten in place)

Frontmatter: keep name `design-scout`, tools (WebSearch, WebFetch, Read, Grep, Glob, browser
tools), `model: sonnet`. Description updated (bilingual): design reference researcher with two
modes, dispatched by design-agent or used standalone.

- **quick mode** (default for point questions; preserves v1 behavior): one recommendation with
  rationale, spec numbers, rejected alternatives (one line each), sources — each source still
  carrying the evidence contract fields below.
- **survey mode** (for reference mapping): executes assigned rings/axes from the task prompt;
  returns research framing (what was searched, what was excluded) + reference list + gaps
  (missing states, missing flows, monotony) + widen/narrow recommendation.

**Evidence contract — every reference/source returns:**
title; source (link); sourceType; platform; productDomain; userTask; interactionPattern;
dateChecked; freshnessRelevance; taskFit (0–5); platformFit (0–5); transferablePrinciples;
limitations; doNotCopyDirectly (details that must not be transferred literally); confidence;
provenance (SOURCE / SYNTHESIS / SPECULATION).

**sourceType enum:** official-guideline / official-design-system / real-shipped-product /
case-study-or-research / concept-or-visual-inspiration. A popular concept shot is never
evidence of usability — concepts can only inform aesthetics, and the scout must say so.

- Shared rules: free sources only; numbers mandatory; never mix platforms — every reference
  tagged with its platform; both iOS and Android specs when the project targets both;
  read-only (never edits project files); describe screenshots in words; answer in the
  conversation language.
- Fallback duty: if search tools fail or results are insufficient, say so explicitly in the
  output, label anything supplied from internal knowledge as MODEL-KNOWLEDGE with lowered
  confidence, and list what needs later verification. Never fabricate sources or dates.
- Embeds a condensed copy of the ring/tier/scoring method and the evidence contract (agents
  cannot invoke skills; sync note points to research-method.md).

## 8. Component: `mobile-design-patterns` v2 (fork)

- Header reframed: rules are contextual heuristics, not laws. Adds the rule-type check every
  finding must pass: platform rule / usability heuristic / product convention / visual
  preference.
- Core rules rewritten in a compact contextual format: Prefer-statement + Scope + When it
  applies + Alternatives + Evidence (HIG/M3/product) + Confidence + Exceptions.
- Demoted from "Core" to "Candidate patterns (apply conditionally)": floating pill + detached
  FAB as default, swipe-up = search, cards replace whitespace, one-screen-one-job absolutism,
  fixed dark palette, single universal size set.
- Kept as strong defaults with evidence: ≥44px tap targets, keyboard as a layout state,
  one scroll direction per section, empty-state kinds, bottom-sheet-for-context, back
  affordance. Tab bar framed per HIG: navigation between top-level sections, not an action
  container.
- Severity taxonomy replaced: Standard violation / Platform convention conflict / Usability
  risk / Design-system inconsistency / Visual polish / Subjective preference. Audit report
  keeps its structure but uses the new taxonomy; stylistic opinions can no longer earn Major.
- Boundary note embedded: this skill assesses platform applicability and audits; it does not
  drive the full workflow (design-agent does).
- `references/reference-values.md` → `references/examples/notely-ios-dark-reference.md` with a
  disclaimer: measured values from ONE product (Notely, dark iOS notes app) — an example of a
  coherent system, not universal reference values.
- New lean files: `references/platforms/ios.md` (sheets, back gesture, safe area, Dynamic
  Island, HIG type/tap specifics), `references/platforms/android.md` (system/predictive back,
  edge-to-edge, M3 navigation, keyboard behavior). Each ≤ ~80 lines, linking to official docs.
- `references/audit-checklist.md` updated to new severities + rule-type column.
- Build mode: step 6 changes from "apply reference values" to "apply the project's design
  system first; Notely example only as fallback inspiration, stated as such".

## 9. Component: `ersatz-design` v2 (fork)

- New required input: `research_summary` (context, approved AND rejected pattern decisions,
  visual references, platform constraints, existing tokens, novelty level). Without it the
  skill may proceed ONLY in explicitly labeled SPECULATION mode and must say so in the
  rationale. Never starts from a blank slate silently.
- Provenance labels on key decisions: SOURCE (seen in a reference) / SYNTHESIS (combined from
  several) / SPECULATION (new experimental).
- Accent rule relaxed: "prefer a dominant accent strategy; multiple accents require explicit
  semantic or structural justification" (replaces "one true accent color per screen").
- Mood→color table removed; accent derivation order: brand/existing tokens → visual references
  from research → only then taste, labeled SPECULATION. No fixed hex-per-mood mappings.
- Type scales and spacing tables reframed as defaults, not laws; overridden by project DS and
  by evidence from references.
- Explicit separation of concerns in output: visual direction / interaction architecture /
  design system (tokens) / implementation.
- Pre-codegen gate: states inventory, component inventory, token map, interaction spec,
  a11y constraints — all present before code is written.
- Temporal/atemporal classification kept but framed as a lens, not a binary law.

## 10. Research fallback protocol (no/thin live research)

When web search is unavailable, fails, or returns insufficient evidence, the system must:
1. Say so explicitly in the output ("live research not performed / incomplete because …").
2. Never present internal knowledge as live search results; no fabricated sources, links,
   or dates.
3. Lower stated confidence accordingly.
4. Label affected content as MODEL-KNOWLEDGE (inference from training data) instead of
   SOURCE.
5. List concretely what must be verified later, so the research can be re-run.
This protocol lives in research-method.md, in design-scout's rules, and as an orchestrator
invariant.

## 11. Component: `README.md` (user-facing, v1)

Located at `~/.claude/skills/design-agent/README.md`. Contents: short description of the
agent; how to use it (recommended request format: task + platform if known + mode if desired +
constraints); the six modes in one table; good and bad usage examples; explanation of
SOURCE / SYNTHESIS / SPECULATION / MODEL-KNOWLEDGE labels; how mobile / web / cross-platform
routing works and how to override it; current v1 limitations (free sources only, no
Refero/Mobbin, basic web module, no domain knowledge files yet). The README must describe
only what is actually implemented — no promises of deferred features.

## 12. Trigger strategy & collisions

- `design-agent` description claims research and full-cycle asks. Forked `ersatz-design`
  description is toned down: generation engine normally invoked via design-agent; direct use
  only for quick isolated components (then SPECULATION labeling is mandatory). Forked
  `mobile-design-patterns` keeps standalone audit triggers; full redesigns route via
  design-agent.
- The claude.ai plugin copies (`anthropic-skills:*`) stay visible alongside local forks.
  Local descriptions include "(local v2 — supersedes the anthropic-skills copy)" so the model
  prefers them. Updating the claude.ai copies (re-uploading .skill files) is a follow-up.

## 13. Usage scenarios

1. "найди как делают X" → design-agent → platform+context → 1 quick scout → recommendation
   with spec and sources.
2. "исследуй направления для экрана Y, дай варианты" → hybrid/explore → 2–3 survey scouts →
   reference map + pattern matrix + 2–3 directions + decision record.
3. "проверь мой дизайн" → audit mode → platform checklist audit + scout comparison against
   real implementations → findings with new severity taxonomy.
4. "сделай экран Z" → full cycle: research → decisions → platform module + ersatz-design with
   research_summary → builder skills → verification + audit of result.

## 14. Deferred (explicit non-goals for v1)

Extended standalone web-design-patterns skill (v1 web coverage = web-platform.md + web
verification checklist); Refero/Mobbin MCP integration; `domains/*.md` knowledge files (grow
from real sessions); regenerated `.skill` zips for claude.ai re-upload; dedicated
design-memory layer (Claude Code auto-memory covers it).

## 15. Risks

- **Trigger competition** between local forks and plugin copies — mitigated by description
  markers; verify in a fresh session.
- **Method drift** between research-method.md and the condensed copy inside design-scout —
  both files carry a sync note pointing at each other.
- **Over-orchestration** for tiny asks — mitigated by output scaling rules and quick mode.
- **Web module shallowness** — v1 web-platform.md is basic by design; README states it, and
  the extended web skill is the named follow-up.

## 16. Acceptance criteria

Structural:
- All files from the file map exist with valid frontmatter; a fresh session lists
  `design-agent` and both forked skills; `design-scout.md.bak` preserved; no broken relative
  paths between SKILL.md files and their references; README matches implemented capabilities.

Behavioral scenarios (beyond §13):
- **A. Mobile**: RN/Expo screen task handles keyboard state, safe area, and system back —
  platform profile resolves to mobile, mobile modules load, checklist covers all three.
- **B. Web**: responsive or desktop web screen task addresses URL state, focus management,
  and keyboard navigation — web-platform.md loads, web verification checklist runs.
- **C. Cross-platform**: one product task produces distinct mobile and web solutions with the
  four-bucket split (shared / mobile / web / non-transferable), without literal layout
  copying.
- **D. Grounded research**: real shipped products and official guidance are separated from
  concepts; concept shots are never cited as usability evidence.
- **E. Explore**: experimental ideas are allowed and every one is labeled SPECULATION.
- **F. No-live-research fallback**: with search unavailable, the agent states the limitation,
  labels output MODEL-KNOWLEDGE, lowers confidence, lists verify-later items, and fabricates
  no sources.
- ersatz-design v2 refuses ungrounded codegen outside labeled SPECULATION.
- design-scout v2 smoke test: quick dispatch returns the v1-shaped recommendation with
  evidence-contract sources; survey dispatch returns metadata-tagged references.
