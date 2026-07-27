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

- **URL carries shareable, restorable, navigational state** — route, selected entity,
  filters, active tab. Transient UI (open dropdowns, hover, scroll micro-state) does not
  belong in the URL.
- **Refresh must survive.** Reloading returns the user to an equivalent view, not to a reset
  app.
- **Deep links work.** Any shareable state is reachable by URL.
- **Back button semantics never break.** Back navigates view history and is never
  swallowed. Whether a modal pushes a history entry is contextual guidance, not a rule:
  modals representing navigational state (a route-worthy detail view) usually do; light
  transient dialogs usually close on Esc/outside-click without consuming Back — decide per
  user expectation and platform convention.

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
- Pointer targets on touch-capable web: ≈44px effective is a comfort heuristic
  (HIG-derived / WCAG AAA-level), not the AA minimum — WCAG 2.2 AA requires 24×24
  (SC 2.5.8). Below 24 = standard violation; 24–44 = judged by context and audience.
- Keyboard is a first-class input, not an accessibility afterthought — see below.

## Interactive states

Every interactive element defines its **applicable** states from: hover, focus, active,
disabled, loading. Applicability is judged per control, not skipped wholesale — a plain
link rarely needs disabled/loading; a submit button usually needs all five.

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
- **Menu vs select vs listbox vs combobox — distinct controls, don't blur them:**
  *menu* = a list of actions (APG: Menu / Menu button); *native `<select>`* = single choice
  in a form, prefer it before custom widgets; *listbox* = visible selection list, possibly
  multi-select (APG: Listbox); *combobox* = text input + filtered options / autocomplete
  (APG: Combobox). All carry the full keyboard contract (arrows, Enter, Esc, typeahead).
- **Sidebar** — fits: top-level navigation of app-like products; destination count is a
  heuristic, not a rule — many peer destinations favor a sidebar, few may not justify one.
  Collapses to drawer on narrow viewports.
- **Toolbar** — fits: persistent actions on a document/editor surface. APG: Toolbar (one tab
  stop, arrows within).
- **Table** — fits: dense comparable records; sorting, selection, pagination/virtualization.
  Regular tabular data = native HTML `<table>`; the APG Grid pattern applies only to
  managed interactive grids (cell-level navigation/editing). Narrow viewports: priority
  columns, card collapse, or a **contained** horizontally scrollable table region when row
  comparison must be preserved — the page body itself never scrolls horizontally.
- **Multi-panel layout** — list-detail, three-pane. Collapse order on narrow viewports is
  designed, not accidental (detail becomes a page/drawer; list stays the root).
