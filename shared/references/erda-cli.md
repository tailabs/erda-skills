# ERDA CLI Prerequisite

All ERDA skills in this repository rely on `erda-cli` for concrete execution.

## Required Checks

Before doing implementation or operational steps, confirm:

1. `erda` is available in `PATH`
2. `erda version` returns successfully
3. `erda whoami` or the team's equivalent auth check confirms the active login context

Use `shared/scripts/check-erda-cli.sh` for the initial binary check.

## Working Rule

When `erda-cli` is missing or unauthenticated:

- stop before producing commands that imply successful execution
- tell the user exactly which prerequisite failed
- give the minimum next action to fix it

## Command Style

Prefer concrete `erda` commands over abstract descriptions.

Good:

```bash
erda version
erda whoami
```

Avoid:

```text
Use the ERDA CLI to inspect the environment.
```

## Scope Split

- `erda-cicd`: focus on pipeline execution, build history, logs, status checks, and delivery-oriented troubleshooting
- `erda-runtime`: focus on runtime inspection and operations
