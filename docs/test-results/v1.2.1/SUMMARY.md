# v1.2.1 test addendum

**H — full-chain prototype (fresh headless session): PASS.** The one chain not covered in
v1.2 (live research → approved pattern decision → research_summary → ersatz-design →
generated mobile artifact → platform verification) ran end-to-end in a single session:
scout dispatched (2 searches), real RN code generated against project tokens, verification
audited the generated artifact using the severity taxonomy (2 Design-system inconsistency,
1 Usability risk — the mandatory-vocabulary fix from v1.2 scenario A held). Extract:
`H-full-chain.json`.

**Still open (requires the user's desktop session, cannot be tested headlessly):** one
plugin-collision check — say «проведи аудит этого экрана» in a fresh claude.ai desktop
session and confirm the LOCAL skills win over the anthropic-skills plugin copies; if a
plugin copy fires, disable it via plugin management (documented in README/USER-GUIDE).

**CI:** workflow present; first run could not be verified from this environment (gh CLI
unauthenticated) — check the Actions tab; the README badge reflects live status.
