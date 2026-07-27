# Example: Notely (dark-theme iOS notes app) — measured values

> **This is ONE reference product** measured from real frames (393×852, iPhone 15 Pro) — an
> example of a coherent, self-consistent system. These are **NOT universal reference
> values.** Use as inspiration or fallback when the project has no design system; never cite
> as a standard in audits. All values in px @1x.

## Canvas & margins
| Token | Value |
|---|---|
| Frame | 393 × 852 |
| Screen edge margin | 16 (content width 361) |
| Base grid | 4pt (spacings observed: 4, 6, 12, 16, 24, 32) |

## Type scale (role → approx font size / measured line height)
| Role | Size ≈ | Line height | Notes |
|---|---|---|---|
| Empty-state / page title | 24–25 | 33 | centered on empty states |
| Section header | 18–19 semibold | 23 | with chevron ">" affordance, 16px chevron |
| Body / card title | 16–17 | 21 | iOS base body is 17 |
| Secondary / date labels | 13–14 | 18 | uppercase section dates ("FRIDAY, FEB 27") |
| Caption / meta | 12 | 16 | "3h ago", tag labels |
| Nav bar label | 10 | 13 | under 24px icon |

In this design: nothing below 10px anywhere; body never below 16px.

## Colors (dark theme)
| Token | Value |
|---|---|
| Background | #141414 |
| Card / surface | #1F1F1F |
| Nav pill / elevated | ~#434343 at ~70% + background blur |
| Text primary | #FFFFFF |
| Text secondary | ~#8A8A8A |
| Accent (interactive) | #2995FF |
| FAB | #FFFFFF fill, dark icon (max contrast for the one primary action) |
| Event/tag accents | muted, ~60% sat: blue #5E5EC7, red #C76C5E, yellow highlight |

## Bottom navigation (floating pill + FAB)
| Property | Value |
|---|---|
| Pill | 286 × 59, x=16, fully rounded, sits 28px above screen bottom (home-indicator zone) |
| Items | 4 items, each 71 × 47 tap target, 6px inner padding of pill |
| Item content | 24px icon + 10px label, active item gets tinted pill background |
| FAB | 59 × 59 circle, 16px gap from pill, 26px "+" glyph |

## Top bar
| Property | Value |
|---|---|
| Y position | 60 (below status bar) |
| Buttons | 48 × 48, icon 24px, 12px internal padding |
| Home | bell + more (top-right cluster 96×48) |
| Editor | back 48×48 top-left; share + more top-right |
| Sheet/selection mode | ✗ 48×48 top-left, ✓ 48×48 top-right — nothing else |

## Cards
| Property | Value |
|---|---|
| Padding | 16 |
| Inner nested block padding | 12 (one nesting level max) |
| Corner radius | ~16 cards; pill/search fully rounded |
| Section header → card gap | 12 |
| Between sections | 32 |
| Task list rows | 39 high, 24px checkbox, 24 gap between rows |
| Horizontal note cards | 211 × 240, 12 gap, overflow off-screen right (signals scrollability) |

## Bottom sheet (template picker)
| Property | Value |
|---|---|
| Header | title centered (lh 23) at y≈140; ✗ and ✓ 48×48 at y=60 above sheet |
| Search input | 361 × 36, fully rounded, 24px leading icon |
| Content grid | 2 columns, cards 174 × 132, 13 col gap, ~54 row gap (includes label) |
| Motion | background zooms out as sheet rises; swipe-down dismiss |

## Editor contextual toolbar (appears when nav hides)
| Property | Value |
|---|---|
| Bottom-left group | 144 × 48, three 48px icon cells (add-block, more, format) |
| Bottom-right | undo 48 × 48 |
| Y position | 776 (same bottom zone the nav pill occupied) |

## Empty state (first run)
Small illustration (~40×55) upper-center, title (lh 33) + 2-line subtitle centered at ~55%
height, nav bar and FAB retained, FAB is the visual anchor. Instructional popover on first
launch.

## Keyboard state
iPhone keyboard occupies y=552..852 (~300px). Content above must remain meaningful; input
accessory actions sit directly above the keyboard.
