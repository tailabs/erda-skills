---
name: erda-runtime
description: Inspect, operate, and troubleshoot ERDA runtimes through erda-cli-backed workflows. Use when users need help with runtime status, deployment behavior, logs, scaling, restarts, or environment-oriented ERDA troubleshooting.
---

# ERDA Runtime

This skill handles runtime-oriented ERDA tasks.

Read [`../../shared/references/erda-cli.md`](../../shared/references/erda-cli.md) first. Before suggesting runtime operations, verify `erda-cli` availability with `bash shared/scripts/check-erda-cli.sh`.

This skill also includes:

- operational reference: [`references/operations.md`](references/operations.md)
- deterministic prerequisite check: [`scripts/doctor.sh`](scripts/doctor.sh)
- validation prompts: see [`references/operations.md`](references/operations.md)

## Use This Skill For

- checking runtime health and status
- guiding deploy, restart, scale, and log-inspection workflows
- diagnosing runtime failures after deployment
- mapping service symptoms to ERDA runtime actions

## Workflow

1. Identify the org, project, application, environment, and runtime scope.
2. Distinguish between deployment problems, application problems, and infrastructure symptoms.
3. Prefer reversible and low-risk operational guidance first.
4. Use precise runtime language and concrete `erda-cli` commands where appropriate.
5. Call out missing context before suggesting destructive operations.
6. When validating the skill itself, use the command playbooks and validation prompts from the reference file.

## Operational Priorities

- status and recent deployment state
- runtime logs and failing services
- resource pressure or bad scaling assumptions
- config drift between expected and actual environment

## References

- Shared CLI prerequisite: [`../../shared/references/erda-cli.md`](../../shared/references/erda-cli.md)
- Operations reference: [`references/operations.md`](references/operations.md)
