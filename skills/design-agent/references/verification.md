# Verification (design-verifier)

> Runs AFTER synthesis or prototyping — never before. Checks the result against the brief,
> the research, the platform profile, and the design system.

## Shared checklist

- [ ] **Brief match** — the result does what the DesignContext says; primaryJobs are served.
- [ ] **Internal consistency** — same radii/borders/icon style/spacing family throughout;
      no accidental accents from inconsistency.
- [ ] **Hierarchy works** — the intended focal point actually wins; squint test passes.
- [ ] **Tokens used** — values come from the token map, no magic numbers.
- [ ] **States coverage** — empty, loading, error, keyboard (mobile), long-content all
      designed, not implied.
- [ ] **Navigation integrity** — every screen reachable and leavable; back behavior correct
      for the platform.
- [ ] **Provenance labels present** — key decisions carry SOURCE / SYNTHESIS / SPECULATION /
      MODEL-KNOWLEDGE.
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
- [ ] **Reflow** — key widths verified AND 200% zoom without loss (WCAG 1.4.10).
- [ ] **Interactive states** — hover / focus / active / disabled / loading present on every
      interactive element.
- [ ] **Reduced motion respected** — animations honor prefers-reduced-motion.
- [ ] **Density degradation** — tables and multi-panel layouts have a designed narrow-
      viewport behavior (cards, priority columns, collapsed panes) — not page-wide
      horizontal scroll.
