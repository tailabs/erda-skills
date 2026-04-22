---
name: erda-runtime
description: Inspect, operate, and troubleshoot ERDA runtimes through erda-cli-backed workflows. Use when users need help with runtime status, deployment behavior, logs, scaling, restarts, or environment-oriented ERDA troubleshooting.
---

# ERDA Runtime

This skill handles runtime-oriented ERDA tasks.

Do not assume repository-level shared files are present when this skill is installed. Start from the skill-local references and scripts first.

This skill also includes:

- prerequisites and fallback rules: [`references/prerequisites.md`](references/prerequisites.md)
- operational reference: [`references/operations.md`](references/operations.md)
- deterministic prerequisite check: [`scripts/doctor.sh`](scripts/doctor.sh)
- validation prompts: see [`references/operations.md`](references/operations.md)

## Use This Skill For

- checking runtime health and status
- guiding deploy, restart, scale, and log-inspection workflows
- diagnosing runtime failures after deployment
- mapping service symptoms to ERDA runtime actions

## Workflow

1. Verify CLI availability with the skill-local doctor script or direct probing from [`references/prerequisites.md`](references/prerequisites.md).
2. Identify the org, project, application, environment, and runtime scope.
3. Distinguish between deployment problems, application problems, and infrastructure symptoms.
4. Prefer reversible and low-risk operational guidance first.
5. Use precise runtime language and concrete `erda-cli` commands where appropriate.
6. Call out missing context before suggesting destructive operations.
7. When validating the skill itself, use the command playbooks and validation prompts from the reference file.

## Operational Priorities

- status and recent deployment state
- runtime logs and failing services
- resource pressure or bad scaling assumptions
- config drift between expected and actual environment

## References

- Prerequisites and fallback: [`references/prerequisites.md`](references/prerequisites.md)
- Operations reference: [`references/operations.md`](references/operations.md)
