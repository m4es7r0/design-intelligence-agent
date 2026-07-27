# v1.2 fresh-session e2e results — summary

Method: headless `claude -p`, fresh session per test, `--model sonnet`, run 2026-07-27 from
an RN/Expo project directory. Trigger tests (G) used `--allowedTools Skill` with
`--output-format stream-json --verbose`, so the Skill invocation events in the streams are
the **empirical invocation trace**, not a simulation. Scenario tests (A–F) used
`--allowedTools Skill,Task,Agent,Read,Grep,Glob,WebSearch,WebFetch` with micro-budgets.
Per-test extracts (prompt, researchDecision, routingTrace, provenance labels, verdict,
violations) are in the JSON files beside this summary.

## Results

| Test | Verdict | Key fact |
|---|---|---|
| G1 references | PASS | Skill(design-agent) invoked on raw phrase |
| G2 audit | PASS | design-agent, not the mobile fork |
| G3 web visual direction | PASS | design-agent; ersatz did not fire pre-research |
| G4 "сделай экран настроек" | **FAIL → fixed → PASS (G4b)** | expo-native-ui won the trigger race; "сделай экран" added to design-agent description; re-run invoked design-agent |
| G5 desktop web dashboard | PASS | design-agent; mobile modules not loaded |
| A mobile audit | PASS + 1 violation | `use-repository-evidence` (0 searches); found 3 real project bugs; findings used HIGH instead of the severity taxonomy → taxonomy made mandatory vocabulary (modes.md) |
| B web design | PASS + 1 deviation | `run-live-quick`, 1 scout; web module engaged; ersatz stage skipped by session's own scope call ("spec, no code") |
| C cross-platform | PASS | four buckets; combined evidenceBasis observed; gate declined live search with stated reason |
| D grounded | PASS | honest degradation: refused Tier-B claim on Tier-C sourcing; flagged own budget overrun |
| E explore | PASS | speculation labeled `MODEL_KNOWLEDGE · SPECULATION`, "no precedents found" |
| F fallback | PASS | `fallback-no-live-research`; zero links; grounded degradation declared |

## Known caveats (recorded, not softened)

1. **Runner exit codes were lost** for the first batch: the launcher started background
   jobs inside `$(...)` command substitution, orphaning them, so `wait` returned 127 for
   every test. Compensation: stream-json `result` events (authoritative
   `is_error:false` per G run) and complete non-empty A–F outputs; the G4b re-run
   executed in the foreground returned a clean `exit=0`.
2. **Plugin-copy collisions are untestable headlessly** — claude.ai plugin skills
   (anthropic-skills:*) exist only in desktop sessions. One desktop-session check remains
   open; the documented remedy is disabling plugin copies via plugin management.
3. **Ersatz generation stage** was not exercised inside scenario B (see its JSON); its
   research_summary gate is covered by G3 and by earlier in-session tests.
4. Tests ran on sonnet for cost; the orchestrating model in real use may be stronger.
