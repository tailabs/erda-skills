---
name: erda-issue
description: Create and manage ERDA issues via `erda-cli`, including user-confirmed state progression (`next`/`update`) and optional parent-child binding (`bind`).
---

# ERDA Issue

This skill is built around the real `erda-cli issue` command surface and keeps state-changing actions behind explicit user confirmation.

It supports:

- `create`: schema-driven issue creation (user confirms before `erda-cli issue create`)
- `next`: propose the next state based on `erda-cli issue schema` (plan-only; no update)
- `update`: set an explicit target state (user confirms before `erda-cli issue update`)
- `bind`: parent/child issue binding (`inclusion` vs `connection`), also behind confirmation

## Use This Skill For

- creating ERDA issues (bug / task / requirement)
- guiding issue state transitions using `erda-cli issue schema`
- when the user says “go to the next step”, proposing the next target state and asking for confirmation
- binding tasks to requirements (default relation: `inclusion`)
- binding issues as an association (relation: `connection`) when the user explicitly requests “关联/associated”

## Safety Gates (Hard Rules)

1. **No state-changing apply without confirmation**
   - `erda-cli issue create` only after the user explicitly confirms.
   - `erda-cli issue update` only after the user explicitly confirms.
   - `erda-cli issue bind` only after the user explicitly confirms.
2. **`next` is plan-only**
   - `next` must not call `erda-cli issue update`.
   - `next` always asks the user whether to apply.
3. **Stop condition: no wrap-around**
   - If the current state is already the last state in the schema-defined transitions/ordering, `next` must error and instruct the user to use explicit `update --state/--state-id`.

## Workflow

1. Verify CLI availability with the skill-local `scripts/doctor.sh` or rules from `references/prerequisites.md`.
2. Verify authentication with `erda-cli whoami`.
3. Identify issue type context:
   - Use the user-provided type if present.
   - Otherwise, ask for `bug` / `task` / `requirement` when needed for schema-driven behavior.
4. Apply the correct workflow per intent (`create` / `next` / `update` / `bind`) as defined in `references/operations.md`.
5. If `erda-cli issue schema/list` fails due to missing org/project context:
   - stop and request `--org/--project` or `--org-id/--project-id` from the user.

## Review Priorities

- wrong issue type (schema mismatch)
- schema-driven next logic errors (must be derived from `issue schema`, not hard-coded)
- accidentally applying updates during `next` (must remain plan-only)
- wrapping around when `next` reaches the last state (must error)
- relation type confusion (`inclusion` vs `connection`) (must respect user wording or explicit overrides)
- missing org/project context handling (`invalid organization context` must stop and ask)

## References

- Prerequisites and fallback: [`references/prerequisites.md`](references/prerequisites.md)
- Operations playbooks: [`references/operations.md`](references/operations.md)
- `erda-cli issue` command surface is expected to match `erda-cli --help` and subcommand `--help` outputs.

