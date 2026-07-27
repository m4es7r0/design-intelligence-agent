# iOS specifics

Source of truth: https://developer.apple.com/design/human-interface-guidelines

## Sheets
- Detents: medium (~half) and large; custom detents allowed. Grabber shown when resizable.
- Sheet vs push: sheet = self-contained subtask that returns to context; push = descending
  the hierarchy. Don't push for "pick one and come back".
- Sheets get their own close affordance (grabber + swipe-down and/or ✗/Done ≥44pt).

## Back & gestures
- Edge-swipe back is a system contract on pushed screens — never disable it; full-screen
  horizontal carousels near the left edge will fight it.
- Long-press → context menu (peek-style preview + actions) is the platform's "right-click".
- Back-swipe reveals the underlying screen with the system parallax. **Prefer native
  navigation transitions** (UINavigationController / native-stack) over manually mimicking
  the parallax — hand-rolled imitations drift from system feel and break with OS updates;
  mimic only when a custom stack is unavoidable.

## Safe areas
- Respect top (status bar / Dynamic Island) and bottom (home indicator) insets everywhere.
- Bottom bars/pills sit above the home-indicator zone; content may scroll under, controls
  may not.
- Keyboard: use keyboard layout guide / avoidance — the accessory bar sits directly above.

## Type & sizes
- Base body 17pt; Dynamic Type must not break layouts (test at larger sizes).
- Tap targets ≥44×44pt effective.
- SF Symbols: match text size/weight when inline; typical icon sizes 17/20/24pt zones.

## Feel
- Haptics on meaningful state changes (success, selection), not on every tap.
- Respect Reduce Motion: replace parallax/zoom with crossfades.

## RN quirks

> basis: REPOSITORY_SOURCE (this user's project audits/memory) — verify against the current
> RN version before citing as general fact.
- `formSheet` + ScrollView interactions are fragile — test sheet scroll-dismiss conflicts.
- Fabric has border-rendering bugs on some combinations — verify borders on device.
