# Output Formats

Eight deliverable templates. Pick per the Scaling table at the bottom — never dump all of
them on a small ask. Write deliverables in the conversation language.

## 1 Research framing

```
What was researched: <axes actually used>
Constraints applied: <platform profile, context limits>
Directions excluded: <and why>
Search width: <rings covered, number of scouts, sources opened>
Mode: <mode> · Confidence: <high|medium|low>
```

## 2 Reference map

Per reference — the full evidence contract plus the transfer verdict:

```
<title> — <source link>
sourceType: official-guideline | official-design-system | real-shipped-product |
            case-study-or-research | concept-or-visual-inspiration
platform: <tag> · productDomain: <…> · userTask: <…> · interactionPattern: <…>
dateChecked: <date> · freshnessRelevance: <high|medium|low>
taskFit: <0–5> · platformFit: <0–5> · confidence: <…>
evidenceBasis: LIVE_SOURCE | REPOSITORY_SOURCE | USER_PROVIDED | MODEL_KNOWLEDGE (may list several)
derivation: DIRECT | SYNTHESIS | SPECULATION

What to take: <transferablePrinciples>
What NOT to transfer: <doNotCopyDirectly>
Why it fits us: <tie to this product's context>
Limitations: <…>
```

## 3 Pattern matrix

| Task | Option A | Option B | Option C | Recommendation |
|---|---|---|---|---|
| Primary action | FAB | composer CTA | persistent footer | composer CTA |

One row per contested decision; recommendation cell names the winner and one-line why.

## 4 Anti-patterns

Concrete risks tied to THIS product — never generic advice:

```
Do not <pattern> here, because <product-specific reason>.
  e.g. Do not use a detached FAB just because it looks modern:
  the primary action here depends on the message context.
```

## 5 Design directions

2–3 directions, each:

```
<Name> — <safe/platform-familiar | balanced | experimental>
What it optimizes: <…>
Key patterns: <…> (each with evidenceBasis + derivation)
Risk: <…>
```

## 6 Decision record

```
Decision: <what was chosen>
Alternatives considered: <list>
Why rejected: <one line each>
Sources: <links used>
Confidence: <high|medium|low>
Still needs validation: <open questions>
```

## 7 Prototype specification

```
Screen structure: <zones, hierarchy>
Component inventory: <every component, reused vs new>
States inventory: <default/hover/focus/active/disabled/loading/empty/error/keyboard as applicable>
Token map: <colors, type, spacing, radii — names not magic numbers>
Motion: <transitions, durations, reduced-motion behavior>
Gestures / interaction: <per platform>
Responsive / adaptive: <behavior per screen class>
Accessibility: <constraints honored>
Acceptance criteria: <verifiable list>
```

## 8 Cross-platform split

Four buckets, verbatim headings:

```
Stays shared: <product model, terminology, tokens, visual DNA>
Adapts for mobile: <part → mobile pattern>
Adapts for web: <part → web pattern>
Must not transfer literally: <pattern → reason it breaks on the other platform>
```

## Scaling

| Ask | Formats |
|---|---|
| Point question | none of the above — inline recommendation + spec + sources |
| Focused research | 1 + 2 + 6 |
| Broad research | 1 + 2 + 3 + 4 + 5 + 6 |
| Audit | findings report (platform checklist format) + 4 + 6 |
| Prototype | 7 (+ 6 if decisions were made here) |
| Cross-platform synthesis | 1 + 2 + 8 + 6 |
