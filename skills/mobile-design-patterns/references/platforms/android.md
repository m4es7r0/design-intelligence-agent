# Android specifics

Source of truth: https://m3.material.io

## System back & predictive back
- System back (gesture or button) must always work — never swallowed by modals, custom
  navigators, or WebViews without proper back-stack entries.
- Predictive back (Android 14+): the app should opt in; screens peek the destination during
  the gesture. Custom back handling that blocks the preview reads as broken.

## Edge-to-edge & insets
- Edge-to-edge is the default expectation on modern Android: draw behind system bars and
  apply WindowInsets to keep controls out of the gesture/status zones.
- Bottom navigation must pad for the gesture nav bar; content scrolls under, controls don't.

## Navigation
- M3 navigation bar: 3–5 top-level destinations, active indicator pill; navigation, not
  actions.
- Navigation rail on large screens/tablets; modal drawer only when destinations overflow.
- FAB is M3-native for THE primary action; extended FAB when a label helps.

## Keyboard (IME)
- Use IME insets (adjustResize behavior) so inputs and accessory rows rise with the
  keyboard; test multi-window.

## Sizes & color
- Tap targets ≥48×48dp; text ≥ roughly 14sp for body, honor user font scaling.
- Dynamic color (Material You) may recolor your palette — pin brand-critical colors
  explicitly if they must not shift.

## RN quirks (from project memory)
- Edge-to-edge on RN can leave transparent system-bar zones that swallow taps — verify
  bottom-zone touchables on device.
- Compose Text inside RN hybrid trees measures differently — check truncation.
