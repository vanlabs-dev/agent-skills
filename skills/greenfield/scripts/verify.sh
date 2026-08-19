#!/usr/bin/env bash
# greenfield verify helper: deterministic gate for phase 8
# Usage: verify.sh <slug> [project-root]
# Exit 0 = pass, non-zero = fail

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

if [[ ! -d "$ART" ]]; then
  echo "No artifact directory. Run the earlier phases first."
  echo "RESULT: FAIL"
  exit 1
fi

# --- required artifacts ---
required=(
  "01-brainstorm.md"
  "03-spec.md"
  "04-design.md"
  "05-tasks.md"
)

echo "Checking required artifacts..."
for f in "${required[@]}"; do
  if [[ -f "$ART/$f" ]]; then
    echo "  OK  $f"
  else
    echo "  MISSING  $f"
    FAILED=1
  fi
done

# optional but expected late-phase files
for f in 06-implement.md 07-review.md 08-verify.md; do
  if [[ -f "$ART/$f" ]]; then
    echo "  OK  $f"
  else
    echo "  note  $f not present yet"
  fi
done
echo

# --- human approval markers ---
echo "Checking human approval markers..."
if grep -qE '^Approved:' "$ART/03-spec.md" 2>/dev/null; then
  echo "  OK  03-spec.md has Approved line"
else
  echo "  FAIL  03-spec.md missing 'Approved:' line"
  FAILED=1
fi

if grep -qE '^Approved:' "$ART/04-design.md" 2>/dev/null; then
  echo "  OK  04-design.md has Approved line"
else
  echo "  FAIL  04-design.md missing 'Approved:' line"
  FAILED=1
fi
echo

# --- project checks (best-effort) ---
# Test output is not suppressed: the full output is the evidence 08-verify.md
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

if [[ -f "Cargo.toml" ]]; then
  if command -v cargo >/dev/null 2>&1; then
    if cargo test --quiet; then
      echo "  OK  cargo test"
    else
      echo "  FAIL  cargo test"
      FAILED=1
    fi
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
