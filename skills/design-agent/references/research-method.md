# Research Method

> Sync note: a condensed copy of this method lives inside `~/.claude/agents/design-scout.md`.
> When editing either file, keep both in sync.

## Search axes

Never search with one flat query. Decompose the task into axes and build queries from their
combinations:

```
Product:            what the product is        (mental health assistant)
Task:               what the user is doing     (start daily reflection)
Platform:           resolved platform profile  (iOS mobile)
Interaction:        the pattern in play        (conversational onboarding)
State:              which state matters        (first session / empty state)
Visual direction:   the register sought        (calm editorial)
Audience:           who is using it            (returning users)
```

## Rings

- **Ring 0 — exact match.** Same product type, same task, same platform.
  `mental health mobile daily reflection onboarding` · `AI therapy app first session` ·
  `wellness chat onboarding iOS`
- **Ring 1 — adjacent products, same task.**
  `journaling app daily check-in` · `meditation app first session` ·
  `coaching app guided reflection`
- **Ring 2 — same interaction pattern, other domains.**
  `conversational onboarding` · `progressive disclosure chat UI` ·
  `guided questionnaire mobile`
- **Ring 3 — official design systems & standards.** Apple HIG, Material 3, Fluent, Carbon,
  Atlassian, WCAG 2.2, WAI-ARIA APG. Search with `site:` filters:
  `site:developer.apple.com/design sheets` · `site:m3.material.io navigation` ·
  `site:w3.org/WAI/ARIA/apg dialog`
- **Ring 4 — experimental.** Editorial, fashion, games, automotive, concept UI, motion
  experiments. Inspiration only — never usability evidence.

## Widen when

- Fewer than 5–7 truly relevant results.
- All results are visually near-identical (monotony).
- Only one solution shape was found for the task.
- Results come from a single product.
- No full flows — only isolated screens.
- Only pretty screens with no states: keyboard, loading, error, empty, long-content.

## Narrow when

- Mobile and desktop results are mixing.
- Consumer and enterprise results are mixing.
- Visually similar results solve a different user task.
- Similar visuals hide a different information architecture.
- Concept shots are crowding out shipped products.
- Platform or input method doesn't match the profile.
- Results are stale for a fast-moving category.

## Source tiers

- **Tier A — normative.** Apple HIG, Material 3, Fluent, WCAG 2.2, WAI-ARIA APG, official
  design systems. Use for verifiable requirements and platform conventions.
- **Tier B — real shipped products.** Real screens, full flows, states, gestures,
  onboarding, errors, paywalls, keyboard interactions. Free libraries: vp0.com, banani.co,
  pageflows.com, uisources.com, mobbin.com (free tier only). Open them in the browser and
  look at actual screens.
- **Tier C — research & case studies.** Usability studies, HCI papers, public redesign
  case studies, product experiments.
- **Tier D — concepts & visual inspiration.** Dribbble, Behance, Awwwards, Pinterest.
  Sets art direction only.

**Tier D never proves usability. Grounded recommendations require Tier A or B evidence.**

## Scoring

Rate every candidate 0–5 per dimension; rank with the weights:

| Dimension | Weight |
|---|---|
| taskFit | 25% |
| platformFit | 20% |
| domainFit | 15% |
| evidenceQuality | 15% |
| transferability | 10% |
| freshness | 10% |
| visualRelevance | 5% |

**A beautiful screen solving the wrong task loses to a plainer but task-exact flow.**

## Freshness

`dateChecked` is mandatory on every reference — the date the source was actually opened.
`freshnessRelevance` says how much recency matters for the category: fast-moving consumer
UI (high) vs stable enterprise patterns and standards (low). An old HIG page can outrank a
new concept shot.

## Fallback protocol (no/thin live research)

When web search is unavailable, fails, or returns insufficient evidence:

1. State explicitly that live research was not performed or was incomplete, and why.
2. Never present internal knowledge as live results — no fabricated sources, links, or
   dates.
3. Lower stated confidence accordingly.
4. Label affected content `MODEL-KNOWLEDGE` (inference from training data) instead of
   `SOURCE`.
5. List concretely what must be verified later, so the research can be re-run.
