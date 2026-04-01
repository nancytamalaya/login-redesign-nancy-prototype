#!/usr/bin/env bash
set -euo pipefail

# Default Docker /dev/shm (often 64MB) is too small for Chromium multiprocess IPC.
sudo mount -o remount,size=2G /dev/shm 2>/dev/null || true

# Detach: script exits immediately; Chrome keeps running; stdio silenced for callers.
nohup google-chrome-stable \
  --user-data-dir=/tmp/chrome-gui-agent \
  --no-first-run \
  --no-default-browser-check \
  --start-maximized \
  --hide-crash-restore-bubble \
  "$@" </dev/null >/dev/null 2>&1 &
disown