#!/usr/bin/env bash

set -euo pipefail

cli_bin=""
if command -v erda-cli >/dev/null 2>&1; then
  cli_bin="erda-cli"
elif command -v erda >/dev/null 2>&1; then
  cli_bin="erda"
else
  echo "Neither erda-cli nor erda was found in PATH."
  echo "Install the ERDA CLI first, then authenticate before using this skill."
  exit 1
fi

echo "ERDA CLI detected: ${cli_bin}"
echo "Verification commands:"
echo "  ${cli_bin} version"
echo "  ${cli_bin} whoami"
echo "  ${cli_bin} runtime --help"
echo
echo "runtime workflow checks:"
echo "  1. confirm org, project, application, and workspace"
echo "  2. inspect runtime status before restart or scale operations"
echo "  3. use erda-cli commands only after auth succeeds"
