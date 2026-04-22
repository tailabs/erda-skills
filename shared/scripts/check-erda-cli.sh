#!/usr/bin/env bash

set -euo pipefail

quiet=0
if [[ "${1:-}" == "--quiet" ]]; then
  quiet=1
fi

if ! command -v erda >/dev/null 2>&1; then
  if [[ "$quiet" -eq 0 ]]; then
    cat <<'EOF'
erda-cli was not found in PATH.

Install erda-cli first, then authenticate before using ERDA skills.
Typical verification commands:
  erda version
  erda whoami
EOF
  fi
  exit 1
fi

if [[ "$quiet" -eq 0 ]]; then
  echo "erda-cli detected: $(command -v erda)"
  echo "Next checks:"
  echo "  erda version"
  echo "  erda whoami"
fi
