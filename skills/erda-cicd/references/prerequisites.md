# ERDA CI/CD Prerequisites

This skill must remain usable even if repository-level shared files are not installed with the skill.

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
erda-cli pipeline --help
```

If the local executable is `erda` rather than `erda-cli`, use the same commands with `erda`.

## Failure Note

If `whoami` fails, do not immediately assume the user is logged out.

Possible causes include:

- missing authentication
- network reachability problems
- proxy or gateway restrictions

Confirm the failure mode before concluding that the local login state is invalid.

## Fallback Rule

If any referenced helper file is unavailable, do not block on the missing file. Fall back to direct CLI probing and continue with the diagnosis.

Bad behavior:

- "Read ../../shared/references/erda-cli.md first" when that file is unavailable
- "Run ../../shared/scripts/check-erda-cli.sh" when that script is unavailable

Required behavior:

- probe the CLI directly
- state which prerequisite failed
- continue with the rest of the troubleshooting flow if the prerequisite succeeds
