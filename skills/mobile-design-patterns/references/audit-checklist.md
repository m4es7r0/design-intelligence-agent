# Mobile Design Audit Checklist (contextual)

Every item is an **applicability question first**: if the pattern doesn't apply to this
product/context, mark N/A with one line why — absence of a popular pattern is never a
finding by itself. For each applicable item: pass / fail + evidence (number, node,
screenshot region, or code line) + severity from the taxonomy (Standard violation /
Platform convention conflict / Usability risk / Design-system inconsistency / Visual
polish / Subjective preference), **calibrated by observed user impact — never by count
dogma or by "the modern default looks different"**. Tag each finding with its rule type
(platform rule / usability heuristic / product convention / visual preference).

## Navigation — platform rules & conventions

- [ ] **Destination set coherence.** Are the persistent destinations peer-level, and does
      switching frequency justify persistent navigation? Count is one signal among product
      type, switching frequency, and platform convention — flag only when navigation
      demonstrably fails (peers buried, users lost), with the failure stated.
      *Severity: Usability risk when impact shown; otherwise Subjective preference.*
- [ ] **Tab bar carries navigation, not actions.** *Platform rule (HIG/M3) → Platform
      convention conflict.*
- [ ] **Primary action discoverable where THIS product's flow needs it** — composer,
      toolbar, row action, FAB, nav-bar button are all valid forms; form follows product.
      Flag a missing or competing primary affordance, never the absence of a FAB
      specifically. *Usability risk when missing/competing.*
- [ ] **Back path on every non-root screen** — iOS visible back and/or edge-swipe; Android
      system back (and predictive back not swallowed). *Platform rule → Platform convention
      conflict; Usability risk if a screen has no gesture or button path at all.*
- [ ] **Tap targets 44×44pt (iOS) / 48×48dp (Android) in both dimensions** (padded hit
      areas count). *Below 24×24 breaches WCAG 2.2 AA (SC 2.5.8) → Standard violation;
      between 24 and the platform norm → Usability risk or Platform convention conflict by
      control frequency and audience.*
- [ ] **Top bar actions contextual per screen** — a frozen global set is a smell, not a
      crime. *Visual polish.*

## Typography — heuristics, not laws

- [ ] **Direction check:** mobile type is not smaller than its desktop counterpart; iOS
      body base is 17pt (platform fact). The cutoffs (body ≥16, floor 10, captions ≥12,
      ≤6 sizes per screen) are **flagging heuristics** — a fail must state the actual
      impact (unreadable at arm's length, Dynamic Type broken, role scale chaos), not just
      quote the number. *Usability risk when legibility/scaling impact is shown;
      Design-system inconsistency for scale chaos; Visual polish otherwise.*

## Layout — usability heuristics

- [ ] **No conflicting nested gestures** — same-axis scroller-inside-scroller, pan areas
      fighting the page gesture. Static multi-column grids are fine. *Usability risk.*
      (Exception: deliberate, signposted carousels; data-dense pro tools — state it in
      Context.)
- [ ] **Shrunken-desktop test** — does any screen demand simultaneous two-dimensional
      scanning a phone can't support? Judge information-architecture fit; there is no
      "one hero block" rule. *Usability risk when demonstrated.*
- [ ] **Spacing family consistent; screen-edge margins consistent.** *Visual polish.*
- [ ] **Horizontal carousels signal scrollability** (edge bleed or affordance). *Visual
      polish.*

## Structure — product conventions

- [ ] **No padding-on-padding container nesting** (card-in-card-in-card). *Design-system
      inconsistency.*
- [ ] **Screen job clarity** — flag only when tasks demonstrably compete for the same
      attention; home screens, dashboards, and browsing hubs legitimately compose several
      jobs. *Usability risk when competing; otherwise Subjective preference.*

## In-context picks, sheets, gestures — check applicability first

- [ ] **Mid-flow picks keep context.** If choosing an option rips the user to another
      screen and loses their place — flag it. A bottom sheet is ONE common fix, not the
      mandated one: popover (tablet), inline expansion, or a compact picker are equally
      valid. *Usability risk.*
- [ ] **Where sheets ARE used:** dismissible (grabber/swipe and/or explicit close),
      controls at platform hit size. *Visual polish.*
- [ ] **Long-press, if used, has a visible alternative path** for every important action
      (row action, toolbar, detail screen). Long-press is an accelerator, never the only
      door. Absence of long-press is NOT a finding. *Usability risk if long-press-only.*
- [ ] **Transitions feel platform-native** — native navigation transitions preferred;
      hand-rolled parallax mimicry is a smell, not a requirement. *Visual polish /
      Subjective preference.*

## States — usability heuristics

- [ ] **First-run empty state orients** — says what this place is and points to the next
      action. Illustration optional; orientation is the requirement. Flag dead-end
      empties. *Usability risk.*
- [ ] **No-results state** acknowledges the query and offers an exit/correction.
      *Usability risk.*
- [ ] **Keyboard-open variant designed** for input screens; key content and the submit
      path reachable with the keyboard up. *Usability risk.*
- [ ] **Loading/skeletons** for content-heavy screens. *Visual polish.*

## Code-specific (RN / Flutter / SwiftUI / Compose)

- [ ] Spacing/type/colors from tokens or constants, not magic numbers. *Design-system
      inconsistency.*
- [ ] Hit areas expanded where visuals are small (hitSlop / minimumHitTarget /
      contentShape). *Usability risk on sub-platform-norm elements; Standard violation
      below 24×24.*
- [ ] Safe areas respected (status/notch, home indicator, IME insets; bottom controls
      above the gesture zone). *Platform convention conflict.*
- [ ] Navigation structure matches the declared model (tabs vs stack vs sheet
      presentation). *Platform convention conflict.*
- [ ] Accessibility basics: labels on icon buttons, Dynamic Type / font scaling not
      broken. *Standard violation.*
