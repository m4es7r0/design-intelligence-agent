# Modes

The mode is chosen at Step 3 of the workflow: a user-named mode always wins; otherwise infer
from the ask and state your inference so it can be corrected.

## explore

- **Goal:** widen the space when the user gives little specificity or asks for bold options.
- **Ring emphasis:** Rings 1–4 (adjacent products, cross-domain patterns, standards for
  grounding, experimental for stretch). Adjacent industries welcome.
- **Evidence bar:** low by design — but honesty stays. Every idea that was NOT found as a
  shipped pattern is labeled `SPECULATION` with the note: "not found as a shipped pattern —
  agent synthesis from several sources."
- **Output set:** research framing + 3–5 strongly divergent design directions.
- **Labeling:** SOURCE/SYNTHESIS where applicable, SPECULATION mandatory elsewhere.

## grounded

- **Goal:** maximum precision; only what demonstrably exists.
- **Ring emphasis:** Rings 0–3 only. Ring 4 excluded.
- **Evidence bar:** every decision shows origin, dateChecked, alternatives, and limitations.
  No pattern is proposed without evidence. Tier D sources may inform aesthetics only — never
  interaction or structure.
- **Output set:** research framing + reference map + pattern matrix + decision record.
- **Labeling:** SOURCE and SYNTHESIS only; anything that would need SPECULATION is omitted
  or explicitly parked as "unverified idea, out of grounded scope".

## hybrid (default)

- **Goal:** the practical working mode.
- **Ring emphasis:** Rings 0–4, balanced.
- **Evidence bar:** ~70–80% of decisions rest on SOURCE/SYNTHESIS; the remaining 20–30% may
  be SPECULATION, clearly labeled.
- **Output set:** scales to the ask (see SKILL.md Output scaling).

## audit

- **Goal:** separate real problems from taste in an existing design.
- **Inputs:** screenshots, Figma (via MCP — real node numbers, not eyeballing), UI code
  (React Native / Flutter / SwiftUI / Compose), existing design system.
- **Sequence:**
  1. Resolve platform + context (Steps 1–2 as usual).
  2. Run the platform checklist: `mobile-design-patterns` audit mode for mobile, the web
     checklist in `verification.md` for web.
  3. Dispatch a scout to find how real shipped products implement the same tasks; compare.
  4. Report findings using the severity taxonomy (Standard violation / Platform convention
     conflict / Usability risk / Design-system inconsistency / Visual polish / Subjective
     preference) and the rule-type check (platform rule / usability heuristic / product
     convention / visual preference).
  5. Give a fix order: quick wins first, then structural.
- **Labeling:** findings cite numbers and elements; taste is allowed but lands in
  `Subjective preference`, never higher.

## prototype

- **Goal:** turn an approved direction into a specified, built, verified artifact.
- **Precondition:** an approved direction exists — from a prior mode run or an explicit user
  choice. No direction → run hybrid first.
- **Produces:** screen structure, component inventory, token map, states inventory, motion,
  gestures/interaction spec, a11y constraints, acceptance criteria — then routes to builder
  skills (expo/RN for native, hallmark/frontend-design/coss for web, figma skills for Figma).
- **Ends with:** a `verification.md` run on the artifact (+ mobile audit for mobile).

## cross-platform-synthesis

- **Goal:** one product, correct on each platform — NOT a merge of two profiles and NOT
  "make it look identical everywhere".
- **Process:**
  1. Research runs per platform: separate scouts for mobile and web; results never mixed.
  2. Synthesis separates the shared core — product model, terminology, design tokens &
     visual DNA — from the platform-specific: navigation, interaction behavior, information
     density, components.
  3. Each platform gets its platform-appropriate solution; the shared core keeps them one
     product.
- **Output — four buckets, verbatim headings:**
  - `Stays shared` — product model, terms, tokens, visual DNA.
  - `Adapts for mobile` — with the mobile-specific pattern named.
  - `Adapts for web` — with the web-specific pattern named.
  - `Must not transfer literally` — patterns that would break on the other platform, with
    the reason.
- **Labeling:** per-platform evidence carries its platform tag; shared-core decisions are
  usually SYNTHESIS.
