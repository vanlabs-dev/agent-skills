#!/usr/bin/env bash
# greenfield verify helper: deterministic gate before archive
# Usage: verify.sh <slug> [project-root]
# Exit 0 = pass, 1 = fail, 2 = usage error

set -euo pipefail

SLUG="${1:-}"
ROOT="${2:-.}"

if [[ -z "$SLUG" ]]; then
  echo "Usage: $0 <slug> [project-root]"
  echo "Example: $0 add-dark-mode ."
  exit 2
fi

ROOT="$(cd "$ROOT" 2>/dev/null && pwd)" || {
  echo "Project root not found: ${2:-.}"
  exit 2
}

ART="$ROOT/docs/greenfield/$SLUG"
FAILED=0

echo "=== greenfield verify: $SLUG ==="
echo "Project root: $ROOT"
echo "Artifact dir: $ART"
echo

# --- required greenfield artifacts ---
echo "Checking greenfield artifacts..."
if [[ -f "$ART/01-brainstorm.md" ]]; then
  echo "  OK  01-brainstorm.md"
else
  echo "  MISSING  01-brainstorm.md"
  FAILED=1
fi

for f in 07-review.md 08-verify.md 09-ship.md; do
  if [[ -f "$ART/$f" ]]; then
    echo "  OK  $f"
  else
    echo "  note  $f not present yet"
  fi
done
echo

# --- OpenSpec change presence ---
echo "Checking OpenSpec change..."
if [[ -d "$ROOT/openspec/changes/$SLUG" ]]; then
  echo "  OK  openspec/changes/$SLUG"
elif [[ -d "$ROOT/openspec/changes" ]]; then
  echo "  note  openspec/changes exists but no change named $SLUG"
elif [[ -d "$ROOT/openspec" ]]; then
  echo "  note  openspec root exists but no changes directory"
else
  echo "  note  no openspec root found (change may live in a registered store)"
fi
echo

# --- project checks (best-effort) ---
# Output is not suppressed: the full output is the evidence 08-verify.md
# must capture.
echo "Running project checks (if present)..."
cd "$ROOT"

if [[ -f "package.json" ]] && command -v npm >/dev/null 2>&1; then
  if grep -q '"test"' package.json; then
    if npm test; then
      echo "  OK  npm test"
    else
      echo "  FAIL  npm test"
      FAILED=1
    fi
  else
    echo "  skip  npm test (no test script)"
  fi
fi

if [[ -f "pyproject.toml" ]] || [[ -f "pytest.ini" ]] || [[ -d "tests" ]]; then
  if command -v pytest >/dev/null 2>&1; then
    if pytest -q --tb=short; then
      echo "  OK  pytest"
    else
      echo "  FAIL  pytest"
      FAILED=1
    fi
  else
    echo "  skip  pytest (not installed)"
  fi
fi

if [[ -f "Cargo.toml" ]] && command -v cargo >/dev/null 2>&1; then
  if cargo test --quiet; then
    echo "  OK  cargo test"
  else
    echo "  FAIL  cargo test"
    FAILED=1
  fi
fi

if [[ -f "Makefile" ]] && grep -qE '^test:' Makefile; then
  if make test; then
    echo "  OK  make test"
  else
    echo "  FAIL  make test"
    FAILED=1
  fi
fi

echo
if [[ "$FAILED" -eq 0 ]]; then
  echo "RESULT: PASS"
  exit 0
else
  echo "RESULT: FAIL"
  exit 1
fi
