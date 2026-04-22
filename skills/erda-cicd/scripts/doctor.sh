#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
bash "${repo_root}/shared/scripts/check-erda-cli.sh"
echo
echo "cicd workflow checks:"
echo "  1. confirm erda-cli auth before pipeline run, status, history, or logs"
echo "  2. if running a pipeline, confirm the workspace is a clean git repository"
echo "  3. distinguish run creation from status, history, and log inspection"
echo "  4. prefer exact erda-cli pipeline subcommands over generic troubleshooting advice"
