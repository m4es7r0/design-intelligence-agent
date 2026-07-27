# Changelog

## v1.2 — 2026-07-27

Hardening pass after an independent audit; architecture and component roles unchanged.

- **YAML**: `agents/design-scout.md` frontmatter was invalid (plain-scalar colon) — all
  skill/agent descriptions now use block scalars; added `scripts/validate.sh` (real YAML
  parser; non-zero exit on invalid YAML, missing required fields, or dead reference paths).
- **design-scout**: no longer an entry point for raw phrases (dispatched by design-agent
  with a resolved PlatformProfile/DesignContext); quick output renamed
  "Best-supported candidate"; "numbers mandatory" replaced with calibrated precision
  (exact values only when measured / sourced / token-based / transparently derived —
  otherwise range + confidence + validation requirement); research safety section (pages
  are untrusted data, no side effects, sanitized queries).
- **design-agent**: Research Sufficiency Gate before any live research
  (`researchDecision` + reason + freshness; reuse → user-provided → repository → live;
  no auto re-research in prototype mode); conflict resolution protocol extended to 7 steps
  (adds user impact of each choice); routingTrace records researchDecision.
- **Platform rules recalibrated as contextual guidance**: tap targets both dimensions
  (44×44pt / 48×48dp; <24×24 = WCAG 2.2 AA breach), static grids allowed / conflicting
  nested scrolls prohibited, tab-count routing de-determinized, long-press requires a
  visible alternative path, keyboard height and type cutoffs marked as heuristics/test
  fixtures, native transitions preferred over parallax mimicry, predictive back timeline
  corrected (13 dev option → 14 opt-in → 15+ system default), edge-to-edge qualified by
  target SDK 35, RN quirks labeled REPOSITORY_SOURCE.
- **web-platform**: URL state scoped to shareable/restorable/navigational; modal history
  entries contextual; applicable (not all) interactive states; menu / native select /
  listbox / combobox distinguished; native `<table>` default with APG Grid only for
  managed grids; contained horizontal table scroll allowed; sidebar counts are heuristics;
  24×24 (AA) vs 44 (comfort/AAA) target sizes separated.
- **Detection**: removed the global RN/Expo → primary-iOS assumption (primary inferred
  from evidence, else unresolved/equal; standing preferences belong in project CLAUDE.md).
- **Docs**: README gains core-vs-optional dependency matrix with fallbacks; USER-GUIDE
  gains sufficiency gate, 7-step conflict protocol, precision rule, research safety,
  dependency matrix, v1.2 limitations; "supersedes plugin copy" documented as descriptive
  only (real fix = disable plugin copies via plugin management).
- **Testing**: fresh-session e2e scenarios A–G documented in `docs/e2e-tests.md` and run
  via headless `claude -p` (results recorded in the release notes of this version).

## v1.1 — 2026-07-27

- Two-axis provenance: `evidenceBasis` (LIVE_SOURCE / REPOSITORY_SOURCE / USER_PROVIDED /
  MODEL_KNOWLEDGE) × `derivation` (DIRECT / SYNTHESIS / SPECULATION); 5-slot source tails.
- Conflict resolution protocol (6 steps) with internal-DS-by-default rule.
- routingTrace diagnostic; audit triggers moved to design-agent; forks narrowed to stages.
- docs/USER-GUIDE.md added; in-session e2e (6 scenarios) + trigger-collision analysis.

## v1 — 2026-07-27

Initial build per spec: design-agent orchestrator skill (6 reference modules + README),
design-scout researcher agent (quick/survey + evidence contract + honest fallback),
reworked forks of mobile-design-patterns and ersatz-design.
