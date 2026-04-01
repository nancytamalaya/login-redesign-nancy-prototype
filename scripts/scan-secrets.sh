#!/usr/bin/env bash
set -euo pipefail

GITLEAKS_VERSION="8.21.2"
GITLEAKS_BIN="/tmp/gitleaks-${GITLEAKS_VERSION}"

if [ ! -x "$GITLEAKS_BIN" ]; then
  echo "Downloading gitleaks v${GITLEAKS_VERSION}..."
  case "$(uname -s)-$(uname -m)" in
    Linux-x86_64)  PLATFORM="linux_x64" ;;
    Linux-aarch64) PLATFORM="linux_arm64" ;;
    Darwin-x86_64) PLATFORM="darwin_x64" ;;
    Darwin-arm64)  PLATFORM="darwin_arm64" ;;
    *) echo "Unsupported platform: $(uname -s)-$(uname -m)"; exit 1 ;;
  esac
  curl -sSfL \
    "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_${PLATFORM}.tar.gz" \
    | tar xz -C /tmp
  mv /tmp/gitleaks "$GITLEAKS_BIN"
  chmod +x "$GITLEAKS_BIN"
fi

REPORT="/tmp/gitleaks-report.json"

echo "Scanning for secrets..."
"$GITLEAKS_BIN" dir . --exit-code 1 --redact \
  --report-format json --report-path "$REPORT" && {
  echo "No secrets detected."
  exit 0
} || {
  echo ""
  echo "Secrets detected! Remove them before committing."
  echo ""
  if [ -f "$REPORT" ] && command -v jq &>/dev/null; then
    jq -r '.[] | "  \(.File):\(.StartLine) - \(.Description)"' "$REPORT"
  elif [ -f "$REPORT" ]; then
    cat "$REPORT"
  fi
  exit 1
}
