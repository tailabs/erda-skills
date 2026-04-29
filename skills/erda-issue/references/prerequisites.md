# ERDA Issue Prerequisites

This skill must not assume repository-level shared files are present.
It relies on the local `erda-cli` (or `erda`) and requires the user to provide org/project context when the CLI cannot infer it.

## Required Discovery Order

When the skill needs to verify CLI availability:

1. check `command -v erda-cli`
2. if missing, check `command -v erda`
3. if both are missing, stop and tell the user to install the ERDA CLI

## Required Verification Commands

Prefer this minimal auth + help probing sequence:

```bash
erda-cli version
erda-cli whoami
erda-cli issue --help
erda-cli issue create --help
erda-cli issue update --help
erda-cli issue bind --help
erda-cli issue schema --help
```

If the local executable is `erda` rather than `erda-cli`, use the same commands with `erda`.

## Failure Handling: Missing Org/Project Context

Some `erda-cli issue` commands (especially `issue schema` and `issue list`) may fail with an “invalid organization context” style error when org/project cannot be inferred.

Skill behavior:

- stop
- do not guess values
- request the user to provide one of:
  - `--org` + `--project`
  - `--org-id` + `--project-id`

## Fallback Rule

If any helper file is unavailable, do not block.
Fall back to direct CLI probing (the required verification commands above).

