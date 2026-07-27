# Platform Profiles & Router

## Router procedure

Platform routing is the **mandatory first stage** — it runs before research and before any
design skill is invoked. Resolution priority:

1. **User-stated** — always wins.
2. **Detected from materials** — see detection signals below.
3. **Working assumption** — stated with confidence and an explicit invitation to override
   ("Assuming responsive-web, primary desktop — correct me in one line if wrong"), then
   continue. Never stall.

**Hard rule: mobile and web references are never mixed unless cross-platform-synthesis mode
is active** — and even then, research stays per-platform until the synthesis step.

### Detection signals

| Signal | Resolution |
|---|---|
| React Native / Expo code | cross-platform-mobile; primary inferred from project evidence (platform-pair files, docs, handoffs, store config) — otherwise primary: unresolved (treat platforms as equal and say so). A standing iOS-first preference belongs in the project's CLAUDE.md, not here |
| SwiftUI code | ios |
| Jetpack Compose code | android |
| Next.js / Tailwind / Vite web code | responsive-web, or desktop-web if density is high |
| Figma frames ~360–430px wide | mobile family |
| Figma frames ≥1200px wide | desktop-web |
| Mentions of tab bar, sheets, keyboard avoidance | mobile family |
| Mentions of browser navigation, URL, hover, sidebar | web family |

## PlatformProfile schema

```
family:                mobile | web | cross-platform
target:                ios | android | cross-platform-mobile | responsive-web | desktop-web | mobile-web
primary / secondary:   platform priority for cross-platform targets
formFactor:            phone | large-phone | tablet | foldable | desktop | wide-desktop
inputMethods:          touch | mouse | trackpad | keyboard | stylus
navigationEnvironment: native-stack | browser-history | tabs | sidebar | multi-window
screenClasses:         e.g. compact-phone, large-phone / mobile, tablet, desktop, wide-desktop
systemConstraints:     platform obligations (safe-area, software-keyboard, reduced-motion, …)
platformSources:       which official systems govern this work
implementation:        framework / styling / componentLibrary
confidence:            high | medium | low
assumptions:           explicit list of guesses made
```

## Example: cross-platform mobile (React Native / Expo)

```
family: mobile · target: cross-platform-mobile · primary: ios · secondary: android
formFactor: phone, large-phone · inputMethods: touch, keyboard
navigationEnvironment: native-stack, tabs
systemConstraints: safe-area, software-keyboard, ios-back-gesture, android-system-back,
                   reduced-motion
platformSources: Apple HIG, Material 3, React Native platform behavior
implementation: React Native + Expo / project design tokens
```

## Example: responsive web (Next.js + Tailwind)

```
family: web · target: responsive-web
formFactor: desktop primary, adapts to mobile · inputMethods: mouse, trackpad, keyboard, touch
navigationEnvironment: browser-history
screenClasses: mobile, tablet, desktop, wide-desktop
systemConstraints: responsive-reflow, keyboard-navigation, semantic-html, browser-zoom-200,
                   reduced-motion, deep-linking
platformSources: WCAG 2.2, WAI-ARIA APG, relevant web design systems
implementation: Next.js App Router / Tailwind CSS
```

## Source routing

| Context | Primary sources |
|---|---|
| iOS | Apple HIG + real product references |
| Android | Material 3 + OEM/product references |
| Web (any) | WCAG 2.2 + WAI-ARIA APG + relevant web design systems |
| Enterprise / internal tools | Carbon, Fluent, Atlassian Design System |
| Shopify-embedded | Polaris |
| Existing internal design system | **Internal system first by default** — but only while it creates no clear usability, accessibility, or platform conflict; on conflict run the 6-step conflict resolution protocol (SKILL.md, Step 5) |

## Cross-platform mapping

Same product, different correct answers per platform:

| Part | Mobile | Web |
|---|---|---|
| Primary navigation | tab bar / stack | sidebar / top navigation |
| Contextual actions | bottom sheet | popover / dropdown |
| Primary action | footer / FAB / composer | toolbar / inline action |
| Drag and drop | secondary affordance | primary affordance |
| Hover | absent | used |
| Keyboard shortcuts | minimal | full system |
| Data density | lower | higher |
| Multi-panel UI | rare | common |
| Modal presentation | sheet / fullscreen | dialog / drawer |
| Back behavior | system gesture | browser history |

**Transfer the principle, not the literal implementation.**
