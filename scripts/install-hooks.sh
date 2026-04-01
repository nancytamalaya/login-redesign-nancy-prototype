#!/usr/bin/env bash
set -euo pipefail

HOOK_SRC="scripts/pre-commit"
HOOK_DST=".git/hooks/pre-commit"

if [ ! -d ".git" ]; then
  echo "Not a git repository — skipping hook install."
  exit 0
fi

cp "$HOOK_SRC" "$HOOK_DST"
chmod +x "$HOOK_DST"
echo "Installed pre-commit hook."
