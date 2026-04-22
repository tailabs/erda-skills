#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
bash "${repo_root}/shared/scripts/check-erda-cli.sh"
echo
echo "runtime workflow checks:"
echo "  1. confirm org, project, application, and workspace"
echo "  2. inspect runtime status before restart or scale operations"
echo "  3. use erda-cli commands only after auth succeeds"
