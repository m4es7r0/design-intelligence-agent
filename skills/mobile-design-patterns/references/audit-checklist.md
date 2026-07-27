# Mobile Design Audit Checklist

Walk every item. For each: pass / fail / N/A + evidence (number, node, screenshot region, or
code line). The bracket severity is the default — adjust for app context, and never rank a
taste call above Visual polish. Severity vocabulary: Standard violation / Platform
convention conflict / Usability risk / Design-system inconsistency / Visual polish /
Subjective preference.

## Navigation — rule type: platform rule
- [ ] Bottom bar holds a few peer destinations; 3–4 preferred [Platform convention conflict
      if 6+, Visual polish if 5]
- [ ] Tab bar contains navigation, not actions [Platform convention conflict]
- [ ] Primary action visually distinct (FAB or broken-out button) — where the candidate
      pattern fits the app [Visual polish]
- [ ] If >5 top-level destinations existed, nav-as-homepage was considered [Platform
      convention conflict]
- [ ] All tap targets meet the platform hit area in BOTH dimensions — 44×44pt iOS /
      48×48dp Android — nav items, icon buttons, list rows, close buttons. Below 24×24 is
      also a WCAG 2.2 AA breach (SC 2.5.8) [Standard violation if <24×24; else Usability
      risk or Platform convention conflict by context]
- [ ] Top bar actions contextual per screen, not a frozen global set [Visual polish]
- [ ] Back affordance on every non-root screen (button and/or swipe; Android system back
      works) [Platform convention conflict]

## Typography — rule type: platform rule / usability heuristic
- [ ] Body text ≥16px (iOS base 17) — mobile type not smaller than desktop; heuristic
      cutoff, honor Dynamic Type [Platform convention conflict]
- [ ] Nothing below 10px; captions ≥12px preferred — heuristic cutoffs for flagging, judge
      legibility in context [Usability risk]
- [ ] ≤6 distinct sizes per screen; consistent role scale across screens [Design-system
      inconsistency]
- [ ] Line heights breathe (~1.3× size); text not squished to fit more [Visual polish]

## Layout — rule type: usability heuristic
- [ ] No conflicting nested scrolls/pans — one clear gesture direction per surface; static
      multi-column grids are fine, scroller-inside-scroller on the same axis or fighting
      pan areas are not (exception: data-dense pro tools, stated in Context) [Usability
      risk]
- [ ] Screen isn't a shrunken desktop: one hero block, not five competing modules
      [Usability risk]
- [ ] 4pt-family spacing; screen edge margins consistent [Visual polish]
- [ ] Horizontal carousels visibly bleed off-screen edge (scroll affordance) [Visual polish]

## Structure & blocks — rule type: product convention
- [ ] Content composed from a small consistent block vocabulary [Subjective preference]
- [ ] No double-nested cards (card-in-card-in-card) [Design-system inconsistency]
- [ ] Inside cards, grouping uses whitespace before another container [Visual polish]
- [ ] Screens have a clear job; new functionality got a new page/sheet, not a denser layout
      (home/dashboards may legitimately compose) [Usability risk if truly overloaded,
      else Subjective preference]

## Sheets, gestures, actions — rule type: platform rule / product convention
- [ ] In-context picks use bottom sheets, not page navigation that rips the user away
      [Usability risk]
- [ ] Sheet anatomy: rounded top, title, confirm+close ≥44px, optional search [Visual polish]
- [ ] Long-press affordance on primary content items (menu or preview), with one-time hint
      [Visual polish]
- [ ] Contextual actions appear/disappear with mode; chrome hides in focused modes
      [Visual polish]
- [ ] Transitions specified: back-swipe parallax, sheet motion [Subjective preference in
      static mockups, Visual polish in code]

## States — rule type: usability heuristic
- [ ] First-run empty state: illustration + title + explanation + primary-action emphasis
      [Usability risk]
- [ ] No-results state: acknowledges query, suggests correction, offers exit [Usability risk]
- [ ] Keyboard-open variant designed for every input screen; key content not buried
      [Usability risk]
- [ ] Loading/skeleton states for content-heavy screens [Visual polish]

## Code-specific (RN / Flutter / SwiftUI / Compose) — rule type: design-system
- [ ] Spacing/type/colors from tokens or constants, not magic numbers [Design-system
      inconsistency]
- [ ] Hit areas expanded where visuals are small (hitSlop / minimumHitTarget / contentShape)
      [Usability risk if missing on <44px elements]
- [ ] Safe areas respected (notch, home indicator; bottom bar above indicator zone)
      [Platform convention conflict]
- [ ] Nav structure matches the declared model (tabs vs stack vs sheet) [Platform
      convention conflict]
- [ ] Accessibility basics: labels on icon buttons, Dynamic Type not broken [Standard
      violation]
