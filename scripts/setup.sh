#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

info()  { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn()  { printf "${YELLOW}⚠${NC} %s\n" "$1"; }
error() { printf "${RED}✗${NC} %s\n" "$1" >&2; }
step()  { printf "\n${BOLD}▸ %s${NC}\n" "$1"; }

die() {
  error "$1"
  exit 1
}

cleanup() {
  if [[ -n "${DEV_PID:-}" ]] && kill -0 "$DEV_PID" 2>/dev/null; then
    kill "$DEV_PID" 2>/dev/null
    wait "$DEV_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

# ─── 1. Authenticate with ac ─────────────────────────────────────────────────

step "Logging in with ac..."

if ! ac login; then
  die "ac login failed. Verify your credentials and network connectivity."
fi
info "Authenticated successfully."

# ─── 2. Stash local changes & reset to origin/main ──────────────────────────

step "Preparing local repository..."

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  die "Not inside a git repository. Run this script from within the cloned project."
fi

HAS_CHANGES=false
git diff --quiet 2>/dev/null        || HAS_CHANGES=true
git diff --cached --quiet 2>/dev/null || HAS_CHANGES=true
[[ -z "$(git ls-files --others --exclude-standard)" ]] || HAS_CHANGES=true

if $HAS_CHANGES; then
  warn "Local changes detected — stashing (including untracked files)..."
  git stash push -u -m "auto-stash before project reset ($(date +%Y-%m-%d_%H:%M:%S))" \
    || die "git stash failed."
  info "Changes stashed. Recover later with 'git stash pop'."
else
  info "Working tree is clean — nothing to stash."
fi

if ! git fetch origin main 2>/dev/null; then
  REMOTE_URL=$(git remote get-url origin 2>/dev/null || true)
  if [[ "$REMOTE_URL" == https://github.com/* ]]; then
    SSH_URL="${REMOTE_URL/https:\/\/github.com\//git@github.com:}"
    warn "HTTPS fetch failed — switching origin to SSH ($SSH_URL)..."
    git remote set-url origin "$SSH_URL" || die "Failed to update remote URL."
    git fetch origin main || die "Failed to fetch origin/main over SSH. Check your SSH key configuration."
    info "Remote switched to SSH."
  else
    die "Failed to fetch origin/main. Check your remote configuration and credentials."
  fi
fi

git checkout main 2>/dev/null || git checkout -b main origin/main \
  || die "Failed to check out main."
git reset --hard origin/main || die "Failed to reset to origin/main."
info "Local repository reset to origin/main."

# ─── 3. Load nvm if node is not already in PATH ─────────────────────────────

if ! command -v node &>/dev/null; then
  if [[ -s "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ]]; then
    warn "'node' not in PATH — loading nvm..."
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    # shellcheck source=/dev/null
    . "$NVM_DIR/nvm.sh"
  fi
fi

# ─── 4. Install dependencies ────────────────────────────────────────────────

step "Installing dependencies (npm ci)..."

if ! npm ci; then
  die "npm ci failed. Verify registry access and network connectivity."
fi
info "Dependencies installed."

# ─── 5. Start dev server & open in Cursor browser ───────────────────────────

step "Starting development server..."

DEV_PORT="${PORT:-5173}"
npm run dev &
DEV_PID=$!

MAX_WAIT=30
elapsed=0
until curl -sf "http://localhost:$DEV_PORT" >/dev/null 2>&1; do
  if ! kill -0 "$DEV_PID" 2>/dev/null; then
    die "Dev server process exited unexpectedly."
  fi
  if [[ $elapsed -ge $MAX_WAIT ]]; then
    die "Dev server did not respond within ${MAX_WAIT}s."
  fi
  sleep 1
  ((elapsed++))
done

info "Dev server running at http://localhost:$DEV_PORT"

if command -v cursor &>/dev/null; then
  cursor --open-url "http://localhost:$DEV_PORT" 2>/dev/null \
    && info "Opened in Cursor browser." \
    || warn "Could not open Cursor browser automatically. Visit http://localhost:$DEV_PORT"
elif command -v xdg-open &>/dev/null; then
  xdg-open "http://localhost:$DEV_PORT" 2>/dev/null
  info "Opened in default browser."
else
  warn "Open http://localhost:$DEV_PORT in your browser to view the app."
fi

wait "$DEV_PID"
