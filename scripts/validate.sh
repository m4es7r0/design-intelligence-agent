#!/usr/bin/env bash
# Frontmatter + reference-path validator for the design-intelligence-agent bundle.
# Usage: scripts/validate.sh [ROOT]   (default ROOT = repo root)
# Exit non-zero on: invalid YAML, missing required fields, missing relative reference
# paths, duplicate skill/agent names.
# Dev dependency: PyYAML — if the system python3 lacks it, a venv is created in
# scripts/.venv and pyyaml is installed FROM THE NETWORK (documented behavior).
# Scope limits (deliberate): does NOT check docs/ links, absolute ~/.claude references,
# frontmatter field types beyond presence, trigger collisions, or evidence enum values.
set -u
ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
PY=python3

if ! $PY -c "import yaml" 2>/dev/null; then
  VENV="$(dirname "$0")/.venv"
  if [ ! -x "$VENV/bin/python3" ]; then
    $PY -m venv "$VENV" || exit 2
    "$VENV/bin/pip" install -q pyyaml || exit 2
  fi
  PY="$VENV/bin/python3"
  $PY -c "import yaml" 2>/dev/null || { echo "FATAL: pyyaml unavailable"; exit 2; }
fi

$PY - "$ROOT" <<'EOF'
import os, re, sys, glob
import yaml

root = sys.argv[1]
failures = []
checked = 0

def frontmatter(path):
    text = open(path, encoding="utf-8").read()
    if not text.startswith("---"):
        raise ValueError("no frontmatter block")
    parts = text.split("---", 2)
    if len(parts) < 3:
        raise ValueError("unterminated frontmatter block")
    return yaml.safe_load(parts[1]), text

targets = sorted(glob.glob(os.path.join(root, "skills", "*", "SKILL.md"))) + \
          sorted(f for f in glob.glob(os.path.join(root, "agents", "*.md"))
                 if not f.endswith(".bak"))

if not targets:
    print(f"FATAL: no targets found under {root}")
    sys.exit(2)

seen_names = {}
for path in targets:
    rel = os.path.relpath(path, root)
    checked += 1
    try:
        data, text = frontmatter(path)
    except Exception as e:
        failures.append(f"{rel}: INVALID YAML :: {str(e)[:140]}")
        continue
    if not isinstance(data, dict):
        failures.append(f"{rel}: frontmatter is not a mapping")
        continue
    required = ["name", "description"]
    if os.sep + "agents" + os.sep in path:
        required += ["tools", "model"]
    for field in required:
        if field not in data or data[field] in (None, ""):
            failures.append(f"{rel}: missing required field '{field}'")
    name = data.get("name")
    if name:
        if name in seen_names:
            failures.append(f"{rel}: duplicate name '{name}' (also in {seen_names[name]})")
        seen_names[name] = rel
    # reference paths mentioned in the body must exist relative to the file's directory;
    # a leading '/' means it's a segment of a longer (absolute/cross-file) path — skip those
    base = os.path.dirname(path)
    for ref in sorted(set(re.findall(r"(?<![\w/~.])references/[A-Za-z0-9_./-]+\.md", text))):
        if not os.path.isfile(os.path.join(base, ref)):
            failures.append(f"{rel}: missing reference path '{ref}'")

if failures:
    print(f"VALIDATION FAILED ({len(failures)} problem(s), {checked} file(s) checked):")
    for f in failures:
        print(f"  - {f}")
    sys.exit(1)
print(f"VALIDATION OK: {checked} file(s) checked, all YAML valid, fields present, reference paths resolve.")
EOF
exit $?
