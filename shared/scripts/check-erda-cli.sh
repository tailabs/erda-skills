#!/usr/bin/env bash

set -euo pipefail

quiet=0
if [[ "${1:-}" == "--quiet" ]]; then
  quiet=1
fi

cli_bin=""
if command -v erda-cli >/dev/null 2>&1; then
  cli_bin="erda-cli"
elif command -v erda >/dev/null 2>&1; then
  cli_bin="erda"
fi

if [[ -z "$cli_bin" ]]; then
  if [[ "$quiet" -eq 0 ]]; then
    cat <<'EOF'
Neither erda-cli nor erda was found in PATH.

Install erda-cli first, then authenticate before using ERDA skills.
Typical verification commands:
  erda-cli version
  erda-cli whoami
EOF
  fi
  exit 1
fi

if [[ "$quiet" -eq 0 ]]; then
  echo "ERDA CLI detected: ${cli_bin} ($(command -v "${cli_bin}"))"
  echo "Next checks:"
  echo "  ${cli_bin} version"
  echo "  ${cli_bin} whoami"
fi
