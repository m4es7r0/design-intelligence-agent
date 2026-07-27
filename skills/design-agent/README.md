# Design Intelligence Agent — User Guide

## What this is

A design system for Claude Code that researches before it designs. Instead of generating UI
from LLM defaults, it resolves your platform, searches live sources (official guidelines +
real shipped products), scores what it finds, and only then makes design decisions — each one
labeled with where it came from. It orchestrates `design-scout` (research agent),
`mobile-design-patterns`, `ersatz-design`, and your builder skills.

## How to ask

Recommended request shape — all parts optional except the task:

```
<task> + <platform, if you know it> + <mode, if you want one> + <constraints>

"Найди как живые приложения делают историю чатов. iOS, grounded."
"Design a settings screen for the habit tracker. Cross-platform. Keep our tokens."
```

Platform and mode are auto-detected when omitted — the agent echoes back what it resolved
("Assuming responsive-web, confidence medium") and you can override it in one line.

## Modes

| Mode | Use when |
|---|---|
| explore | You want directions, breadth, bold ideas — speculation welcome, always labeled |
| grounded | You want only what demonstrably exists, with origins and dates |
| hybrid (default) | Normal work: mostly evidence, some labeled synthesis |
| audit | You have a design (screenshots / Figma / code) and want it checked |
| prototype | A direction is approved and you want a spec + built artifact |
| cross-platform-synthesis | One product needs correct mobile AND web solutions |

## Good asks vs bad asks

**Good:**
- «Найди как живые приложения делают историю чатов, iOS» — task + platform, point question.
- «Explore: направления для onboarding медитационного приложения, можно смело» — mode + domain.
- «Audit: вот скриншоты, проверь против реальных реализаций» — artifacts + intent.

**Bad:**
- «Сделай красиво» — no task, nothing to research; the agent will have to interrogate you.
- Calling `ersatz-design` directly for a full screen — it will demand a research summary or
  run as labeled SPECULATION; go through `design-agent` instead.

## Labels — two independent axes

Every key decision carries provenance on two axes that never merge:

**evidenceBasis** — what the knowledge rests on (may list several):
- **LIVE_SOURCE** — checked live in this session (guideline page, real product screen).
- **REPOSITORY_SOURCE** — read from your repo (tokens, components, audits).
- **USER_PROVIDED** — rules, references, or constraints you supplied.
- **MODEL_KNOWLEDGE** — the model's training data; used in fallback, confidence lowered,
  needs later verification.

**derivation** — how the conclusion was produced:
- **DIRECT** — taken as-is from the basis.
- **SYNTHESIS** — combined from several inputs.
- **SPECULATION** — new experimental idea, not found shipped anywhere.

So "SYNTHESIS of three live-checked patterns" and "SPECULATION on top of model knowledge"
are both expressible without the labels fighting each other.

Diagnostics: add "покажи routingTrace" to any request to see which modules were invoked
and skipped. Full guide: `docs/USER-GUIDE.md` in the design-intelligence-agent repo.

## Platform routing

The agent resolves platform **first** — family (mobile / web / cross-platform), target,
primary/secondary, form factor, inputs, stack — from your words or your materials, and shows
its assumption if it had to guess. Mobile and web references are never silently mixed. In
cross-platform-synthesis mode the output is split into four buckets: **Stays shared / Adapts
for mobile / Adapts for web / Must not transfer literally.**

## Limitations (v1)

- Free sources only — no Refero/Mobbin paid integrations.
- The web module is basic v1 (an extended web-design-patterns skill is planned).
- No per-domain knowledge files yet (chat/health/e-commerce grow from real sessions).
- Research quality depends on live web access — when unavailable, the agent says so and
  labels output `evidenceBasis: MODEL_KNOWLEDGE` instead of inventing sources.
