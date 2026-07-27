---
name: mobile-design-patterns
description: Mobile app UI design patterns — audit existing designs and build screens (local v2 — supersedes the anthropic-skills copy; contextual rules, not absolutes). Use to review, critique, check, or improve a mobile app design (Figma, screenshots, or RN / Flutter / SwiftUI / Compose code), OR to design mobile screens, navigation, bottom sheets, empty states, or convert a desktop layout to mobile. Triggers: "проверь дизайн", "аудит UI", "review my app design", "make this mobile-friendly", "design a mobile screen", "почему UI выглядит плохо" — including phone-sized artifacts (~390px frames) without the word "mobile". For full redesigns and research-driven work, start with design-agent instead — this skill assesses and builds, it does not drive the full workflow.
---

# Mobile Design Patterns

Rules here are **contextual heuristics, not laws**. Before flagging or applying any rule,
classify it — `platform rule` / `usability heuristic` / `product convention` / `visual
preference` — and check the app's context: domain, audience, platform, density needs. A pro
trading app legitimately violates density heuristics a notes app shouldn't.

Boundary: this skill assesses mobile applicability, audits, and builds screens. It does not
drive the full design workflow — `design-agent` does; for full redesigns start there.

## Strong defaults (evidence-backed)

### Tap targets
**Prefer** ≥44px effective hit area (44pt iOS / 48dp Android) in at least one dimension for
every interactive element; visuals may be smaller if the hit area is padded.
**Scope:** all mobile. **Evidence:** HIG, M3 (platform rule). **Confidence:** high.
**Exceptions:** none worth having.

### Keyboard is a layout state
**Prefer** designing every input screen with the keyboard open (~300–336px on iPhone): what
stays visible, what the accessory bar holds.
**Scope:** any screen with input. **Evidence:** shipped products across categories
(usability heuristic). **Confidence:** high.

### One scroll direction per section
**Prefer** each section extending in exactly one direction — vertical stack OR horizontal
carousel, never a 2D grid-of-modules inside one section.
**Scope:** consumer mobile. **Evidence:** usability heuristic from mobile reading patterns.
**Confidence:** high. **Exceptions:** data-dense professional tools (trading, dashboards)
where 2D scanning is the job.

### Type not smaller than desktop
**Prefer** body ≥16px (iOS base is 17px), nothing below 10px; don't shrink text to fit more.
**Scope:** all mobile. **Evidence:** HIG type scale (platform rule). **Confidence:** high.

### Empty states, two kinds
**Prefer** distinct first-run (illustration + one-line title + short explanation + primary
action emphasized) and no-results (acknowledge the query + suggest correction + exit action)
states.
**Scope:** any collection/search surface. **Evidence:** usability heuristic. **Confidence:**
high.

### Bottom sheet for in-context picks
**Prefer** a sheet (rounded top, ≥44px confirm/close, optional search) over page navigation
when the user must not lose their place — picking a template while editing, choosing an
option mid-flow.
**Scope:** iOS + Android. **Evidence:** HIG sheets, M3 bottom sheets (platform rule).
**Confidence:** high. **Alternatives:** popover on tablets.

### Back affordance everywhere
**Prefer** every non-root screen exit-able: iOS edge-swipe + visible back; Android system
back / predictive back never swallowed.
**Scope:** all mobile. **Evidence:** HIG, Android platform docs (platform rule).
**Confidence:** high.

### Tab bar is navigation
**Prefer** the tab bar as navigation between a few top-level **peer destinations** — not an
action container; actions don't belong in it.
**Scope:** iOS + Android. **Evidence:** Apple HIG Tab bars, M3 navigation bar (platform
rule). **Confidence:** high.

## Candidate patterns (apply conditionally — NOT defaults)

### Floating pill + detached FAB
**Fits when:** 3–4 peer destinations + one dominant create action; consumer apps.
**Doesn't when:** the primary action depends on screen context; pro/dense tools.
**Evidence:** shipped consumer apps (product convention). **Confidence:** medium.

### Nav-as-homepage (sidebar becomes home, like Notion)
**Fits when:** >5 genuinely peer destinations; browsing/workspace products.
**Doesn't when:** 3–4 destinations cover the product — a tab bar is simpler.
**Evidence:** Notion, workspace products (product convention). **Confidence:** medium.

### Swipe-up-for-search
**Fits when:** search is THE power action and the gesture gets a one-time onboarding hint.
**Doesn't when:** search is secondary — hidden gestures on secondary actions just get lost.
**Evidence:** Slack, iOS home (product convention, not a standard). **Confidence:** low.

### Cards as the grouping tool
**Fits when:** heterogeneous blocks need visible boundaries.
**Doesn't when:** text-first reading surfaces — whitespace grouping is equally valid; and
never double-nest cards (one inner tinted block at reduced padding is the max).
**Evidence:** product convention. **Confidence:** medium.

### One screen = one job
**Fits as a strong tendency:** settings is settings, the editor is the editor.
**Doesn't as an absolute:** home screens, dashboards, and browsing hubs legitimately
compose several jobs.
**Evidence:** usability heuristic. **Confidence:** medium.

### Long-press peek / context menu
**Fits when:** collections of content items; needs a discoverability hint once.
**Evidence:** iOS context menus (platform rule on iOS, convention on Android).
**Confidence:** medium.

## Audit mode

Inputs: Figma link (use the Figma MCP — get_metadata for real sizes, get_screenshot for
visuals; verify numbers from nodes, not eyeballing), app screenshots, or UI code (RN /
Flutter / SwiftUI / Compose — component tree, style constants, navigation setup).

1. **Inventory + context** — screens/components available; domain, platform, theme, density
   needs.
2. **Checklist** — run `references/audit-checklist.md` systematically.
3. **Classify every finding** by rule type: platform rule / usability heuristic / product
   convention / visual preference.
4. **Report:**

```
# Mobile Design Audit: [app]
## Context
[domain, platform, appropriate density/style and why]
## Summary
[2–3 sentences, verdict, top 3 issues]
## Findings
- **[Severity]** [rule violated] ([rule type]) — [screen/component]
  - What: [observation with numbers]
  - Why it matters: [user impact]
  - Fix: [concrete change with target values, respecting the app's context]
## What's already good
## Suggested fix order
[quick wins first, then structural]
```

Severity taxonomy — use exactly these: **Standard violation** (breaks a normative
requirement — WCAG, platform hard rule) · **Platform convention conflict** (fights HIG/M3
expectations) · **Usability risk** (measurably hurts use: <44px targets, unreachable
actions, keyboard burying input) · **Design-system inconsistency** (violates the app's own
tokens/patterns) · **Visual polish** (spacing off-grid, radius drift) · **Subjective
preference** (taste — must be marked as such). Stylistic opinions can never be ranked above
Visual polish.

## Build mode

Work in order — each step constrains the next:

1. **Nav model** — count top-level peer destinations; ≤4 → tab bar (pill+FAB only if the
   candidate pattern fits); >4 → consider nav-as-homepage. Name the primary action.
2. **Screen inventory** — screens + modal sheets; which actions are contextual per screen.
3. **Per-screen layout** — one scroll direction per section; one hero block for home;
   watch card nesting.
4. **States** — first-run empty, no-results, keyboard-open for every relevant screen.
   These are screens, not afterthoughts.
5. **Motion & gestures** — back-swipe parallax, sheet transitions, long-press behavior,
   how contextual actions animate in/out.
6. **Values** — apply the project's design system first. If none exists, you may borrow
   from `references/examples/notely-ios-dark-reference.md` as inspiration — always stating
   it is one example product, not a standard.

Platform specifics: `references/platforms/ios.md`, `references/platforms/android.md`.

## Verification (both modes)

Before delivering: every interactive element ≥44px hit area? Every section unidirectional
(or justified by context)? Card-in-card anywhere? Empty + keyboard states covered? Every
finding cites a number or element, names its rule type, and respects the stated app context?
Any taste-based finding honestly tagged Subjective preference?
