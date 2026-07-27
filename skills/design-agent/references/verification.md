# Verification (design-verifier)

> Runs AFTER synthesis or prototyping — never before. Checks the result against the brief,
> the research, the platform profile, and the design system.

## Shared checklist

- [ ] **Brief match** — the result does what the DesignContext says; primaryJobs are served.
- [ ] **Internal consistency** — same radii/borders/icon style/spacing family throughout;
      no accidental accents from inconsistency.
- [ ] **Hierarchy works** — the intended focal point actually wins; squint test passes.
- [ ] **Tokens used** — values come from the token map, no magic numbers.
- [ ] **States coverage** — all states APPLICABLE to this screen and flow are designed,
      not implied (empty, loading, error, keyboard on mobile, long-content — judged per
      surface, not demanded universally).
- [ ] **Navigation integrity** — every screen reachable and leavable; back behavior correct
      for the platform.
- [ ] **Provenance present, both axes** — key decisions carry evidenceBasis (LIVE_SOURCE /
      REPOSITORY_SOURCE / USER_PROVIDED / MODEL_KNOWLEDGE) AND derivation (DIRECT /
      SYNTHESIS / SPECULATION); the axes are never merged into one label.
- [ ] **Conflict records complete** — every internal-vs-external conflict resolved in the
      7-step protocol format (SKILL.md, Step 5), including user impact of each choice,
      confidence, and required validation.
- [ ] **No false precision** — every exact value is measured, sourced, token-based, or
      transparently derived; anything else is a range with confidence and a validation
      requirement.
- [ ] **Divergence justified** — where the result departs from the chosen references, the
      decision record says why.
- [ ] **AI-slop scan** — no purple-gradient hero by default, no generic 3-card feature row,
      no emoji section headers, no evenly-weighted everything, no decorative glassmorphism
      that serves no register. For web aesthetics, defer to hallmark's judgment when it runs.

## Mobile

Run `mobile-design-patterns` **audit mode** on the produced result. Findings use its severity
taxonomy (Standard violation / Platform convention conflict / Usability risk /
Design-system inconsistency / Visual polish / Subjective preference).

## Web checklist

- [ ] **URL/history state** — refresh returns an equivalent view; deep links work; back is
      never broken or swallowed.
- [ ] **Keyboard operability end-to-end** — every flow completable without a pointer; no
      traps; logical tab order.
- [ ] **Visible focus states** — every interactive element; no removed outlines without
      replacement.
- [ ] **Managed focus order** — dialogs trap and restore focus; route changes move focus.
- [ ] **Semantics** — landmarks, heading structure, native elements before ARIA.
- [ ] **Hover-independent** — nothing is reachable only by hover (touch parity).
- [ ] **Resize Text** — text usable at 200% zoom (WCAG 1.4.4).
- [ ] **Reflow** — no two-dimensional scrolling at an equivalent viewport width of 320 CSS
      px, e.g. 400% zoom on 1280px (WCAG 1.4.10); key intermediate widths verified.
- [ ] **Interactive states** — all APPLICABLE semantic states are defined per control
      (hover/focus/active/disabled/loading where they make sense — a link rarely needs
      loading; a submit button usually needs all five).
- [ ] **Reduced motion respected** — animations honor prefers-reduced-motion.
- [ ] **Density degradation** — tables and multi-panel layouts have a designed narrow-
      viewport behavior (cards, priority columns, collapsed panes) — not page-wide
      horizontal scroll.
