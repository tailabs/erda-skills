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
echo
echo "Verification commands:"
echo "  ${cli_bin} version"
echo "  ${cli_bin} whoami"
echo "  ${cli_bin} issue --help"
echo "  ${cli_bin} issue create --help"
echo "  ${cli_bin} issue update --help"
echo "  ${cli_bin} issue bind --help"
echo "  ${cli_bin} issue schema --help"
echo
echo "Note:"
echo "  Some \`issue schema\` / \`issue list\` calls may require org/project context."
echo "  If you see an 'invalid organization context' error, pass --org/--project or --org-id/--project-id."

