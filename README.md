# Design Intelligence Agent

![validate](https://github.com/m4es7r0/design-intelligence-agent/actions/workflows/validate.yml/badge.svg)

A research-first design system for Claude Code: it resolves the platform, searches live
sources (official guidelines + real shipped products), scores the evidence, and only then
makes design decisions — each key decision labeled with evidenceBasis and derivation.

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
docs/USER-GUIDE.md              полное руководство пользователя (RU)
docs/                           design spec + implementation plan (v1 snapshots)
```

## Install (on any machine with Claude Code)

**Symlink mode (recommended — this repo stays the single source of truth; verified to work
with Claude Code skill/agent discovery):**

```bash
REPO="$(pwd)" && mkdir -p ~/.claude/skills ~/.claude/agents \
  && ln -s "$REPO/skills/design-agent" ~/.claude/skills/design-agent \
  && ln -s "$REPO/skills/mobile-design-patterns" ~/.claude/skills/mobile-design-patterns \
  && ln -s "$REPO/skills/ersatz-design" ~/.claude/skills/ersatz-design \
  && ln -s "$REPO/agents/design-scout.md" ~/.claude/agents/design-scout.md
```

Edits made in the repo are live immediately for new sessions; commit them here — no
copy-back step exists anymore.

**Copy mode (portable, no repo left on the machine):**

```bash
cp -R skills/design-agent skills/mobile-design-patterns skills/ersatz-design ~/.claude/skills/
mkdir -p ~/.claude/agents && cp agents/design-scout.md ~/.claude/agents/
```

Either way, new Claude Code sessions list `design-agent`, both forked skills, and the
`design-scout` agent automatically. Run `./scripts/validate.sh` before committing changes.

## Use

Write design asks normally — «найди как делают X», «исследуй направления Y»,
«audit: вот скриншоты», "design this screen" — the `design-agent` skill triggers itself.
Name a mode (explore / grounded / hybrid / audit / prototype / cross-platform-synthesis)
and platform explicitly when you want control; otherwise they are auto-detected and echoed
back for override. Details: `skills/design-agent/README.md`.

### Быстрый тест агента на существующем проекте

Запустите Claude Code из корня проекта и отправьте:

> Работай через design-agent. Изучи этот проект, определи платформу и существующие функции.
> Проведи аудит основного пользовательского flow, найди несколько актуальных реальных
> референсов, предложи 2–3 направления улучшения и выбери одно. Создай research_summary,
> реализуй выбранное решение как изолированный prototype, не удаляя текущий UI, затем
> выполни platform verification. В конце покажи изменённые файлы, команды запуска и
> routingTrace.

Такой запрос проверяет основную цепочку:

`repository → platform routing → audit → research → synthesis → prototype → verification`.

## Invariants

- Platform resolves before research; mobile and web references never mix silently.
- Generation (`ersatz-design`) never runs first and never without a research summary,
  except in labeled SPECULATION mode.
- Fallback output is labeled `evidenceBasis: MODEL_KNOWLEDGE` — never dressed up as live
  research, never with fabricated links. Provenance is two-axis: evidenceBasis (LIVE_SOURCE /
  REPOSITORY_SOURCE / USER_PROVIDED / MODEL_KNOWLEDGE) × derivation (DIRECT / SYNTHESIS /
  SPECULATION).

## Current limitations (v1.2.1)

Free sources only (no Refero/Mobbin integrations); basic web module (extended
web-design-patterns skill planned); no per-domain knowledge files yet.
