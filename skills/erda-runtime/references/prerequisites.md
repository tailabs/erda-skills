# ERDA Runtime Prerequisites

This skill must not depend on repository-level shared files to remain usable.

## Required Discovery Order

When the skill needs to verify CLI availability:

1. check `command -v erda-cli`
2. if missing, check `command -v erda`
3. if both are missing, stop and tell the user to install the ERDA CLI

## Required Verification Commands

Prefer this minimal sequence:

```bash
erda-cli version
erda-cli whoami
erda-cli runtime --help
```

If the local executable is `erda` rather than `erda-cli`, use the same commands with `erda`.

## Fallback Rule

If any helper file is unavailable, do not block on the missing file. Fall back to direct CLI probing and continue with the diagnosis.
