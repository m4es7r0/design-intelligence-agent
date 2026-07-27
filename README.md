# Design Intelligence Agent

A research-first design system for Claude Code: it resolves the platform, searches live
sources (official guidelines + real shipped products), scores the evidence, and only then
makes design decisions — each labeled SOURCE / SYNTHESIS / SPECULATION / MODEL-KNOWLEDGE.

## Contents

```
skills/design-agent/            orchestrator skill — the single entry point
  ├── SKILL.md                  workflow: Platform Router → context → mode → research →
  │                             synthesis → generation routing → verification
  ├── README.md                 user guide (modes, labels, how to ask, limitations)
  └── references/               modes · research-method · platform-profiles ·
                                web-platform · output-formats · verification
skills/mobile-design-patterns/  fork v2 — contextual rules, severity taxonomy,
                                Notely demoted to example, ios/android platform notes
skills/ersatz-design/           fork v2 — research_summary gate, provenance labels,
                                no mood→hex table, pre-codegen gate
agents/design-scout.md          researcher agent — quick/survey modes, evidence contract,
                                honest no-research fallback
docs/                           design spec + implementation plan
```

## Install (on any machine with Claude Code)

Copy the pieces into the user-level Claude Code directories:

```bash
cp -R skills/design-agent skills/mobile-design-patterns skills/ersatz-design ~/.claude/skills/
mkdir -p ~/.claude/agents && cp agents/design-scout.md ~/.claude/agents/
```

New Claude Code sessions will list `design-agent`, both forked skills, and the
`design-scout` agent automatically.

## Use

Write design asks normally — «найди как делают X», «исследуй направления Y»,
«audit: вот скриншоты», "design this screen" — the `design-agent` skill triggers itself.
Name a mode (explore / grounded / hybrid / audit / prototype / cross-platform-synthesis)
and platform explicitly when you want control; otherwise they are auto-detected and echoed
back for override. Details: `skills/design-agent/README.md`.

## Invariants

- Platform resolves before research; mobile and web references never mix silently.
- Generation (`ersatz-design`) never runs first and never without a research summary,
  except in labeled SPECULATION mode.
- Fallback output is labeled MODEL-KNOWLEDGE — never dressed up as live research, never
  with fabricated links.

## v1 limitations

Free sources only (no Refero/Mobbin integrations); basic web module (extended
web-design-patterns skill planned); no per-domain knowledge files yet.
