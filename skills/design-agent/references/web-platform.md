# Web Platform Module (v1)

> Scope note: this is the v1 basic web module. It assesses platform applicability and
> supplies web constraints — it does not drive the workflow (design-agent does). An extended
> standalone web-design-patterns skill is a planned follow-up.

## Web contexts

- **Responsive web** — one codebase serving every screen class. Content priority decides
  what survives on narrow viewports; navigation typically collapses (sidebar → drawer,
  top nav → menu). Density adapts per class, not fixed.
- **Desktop web application** — app-like products (dashboards, editors, admin tools).
  Higher density is legitimate; persistent chrome (sidebar + toolbar) is normal; keyboard
  shortcuts and multi-panel layouts earn their place.
- **Mobile web** — touch-first browser context. Touch targets and reflow rules from mobile
  apply, but navigation is browser-based (no native stack), there is no system back gesture
  contract, and installability/viewport quirks matter. Do not treat it as "the app, smaller".

## Browser environment

- **URL as state.** Route, selected entity, filters, active tab belong in the URL; transient
  UI (open dropdowns, hover, scroll micro-state) does not.
- **Refresh must survive.** Reloading returns the user to an equivalent view, not to a reset
  app.
- **Deep links work.** Any shareable state is reachable by URL.
- **Back button semantics never break.** Back navigates view history; it must not be
  swallowed by modals or custom routers without pushing appropriate history entries.

## Responsive reflow

- Breakpoints are content-driven, not device-driven — break where the layout stops working.
- Container strategy: max content width for reading surfaces; fluid for data surfaces.
- Content priority on narrow viewports: decide what collapses, stacks, or hides — in that
  order of preference (hiding is last).
- **Zoom to 200% without loss of content or function** (WCAG 1.4.10 reflow).

## Input methods

Mouse, trackpad, keyboard, and touch coexist on the same page — a laptop with a touchscreen
is normal.

- **Hover is never the only path to a function** (touch parity). Hover may enhance, not gate.
- Pointer targets on touch-capable web: comfortable sizes (≈44px effective) for primary
  controls.
- Keyboard is a first-class input, not an accessibility afterthought — see below.

## Interactive states

Every interactive element defines: **hover, focus, active, disabled, loading.**

- Visible focus is non-negotiable (WCAG 2.4.7); never `outline: none` without a replacement.
- Loading is a state of regions, not only pages: skeletons/spinners scoped to the loading
  area, layout stable around them.

## Semantics & accessibility

- **Semantic HTML first.** Native `button`, `a`, `label`, `table`, landmarks and headings
  before any ARIA. ARIA fills gaps; it does not replace semantics.
- **Keyboard navigation end-to-end:** every flow completable without a pointer; logical tab
  order; no keyboard traps.
- **Focus management:** dialogs trap focus and restore it on close; route changes move focus
  to the new content; destructive removals move focus somewhere sensible.
- **Routing targets for verifiable requirements:** WCAG 2.2 for criteria, WAI-ARIA APG for
  component behavior — https://www.w3.org/WAI/ARIA/apg/patterns/ is the pattern index.

## Component patterns

- **Dialog (modal)** — fits: decisions that must interrupt (confirm, required input).
  Doesn't: content browsing (use a page), light context (use a popover). APG: Dialog (Modal).
- **Popover** — fits: light contextual info/actions anchored to a trigger; dismisses on
  outside click/Esc. Doesn't: multi-step flows.
- **Dropdown / menu** — fits: choosing one action or option from a set. Full keyboard
  contract (arrows, Enter, Esc, typeahead). APG: Menu / Menu button, Combobox for filtering.
- **Sidebar** — fits: top-level navigation of app-like products with ≥5 destinations;
  collapses to drawer on narrow viewports.
- **Toolbar** — fits: persistent actions on a document/editor surface. APG: Toolbar (one tab
  stop, arrows within).
- **Table** — fits: dense comparable records; sorting, selection, pagination/virtualization.
  Degrades to cards or a priority-column layout on narrow viewports — never horizontal-only
  scroll of the whole page. APG: Grid.
- **Multi-panel layout** — list-detail, three-pane. Collapse order on narrow viewports is
  designed, not accidental (detail becomes a page/drawer; list stays the root).
