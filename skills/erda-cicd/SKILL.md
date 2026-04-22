---
name: erda-cicd
description: Operate, troubleshoot, and explain ERDA CI/CD workflows through erda-cli. Use when users need help running pipelines, checking status, reading logs, reviewing build history, or diagnosing delivery failures across the build and deploy path.
---

# ERDA CI/CD

This skill focuses on the real `erda-cli` command surface for pipeline and delivery workflows, not just static YAML editing.

Read [`../../shared/references/erda-cli.md`](../../shared/references/erda-cli.md) first. Before giving run or diagnosis commands, verify `erda-cli` availability with `bash shared/scripts/check-erda-cli.sh`.

This skill is backed by command knowledge and working assets:

- command guidance: [`references/cli-capabilities.md`](references/cli-capabilities.md)
- reusable templates: [`assets/templates/basic-pipeline.yml`](assets/templates/basic-pipeline.yml), [`assets/templates/build-release-deploy.yml`](assets/templates/build-release-deploy.yml)
- deterministic prerequisite check: [`scripts/doctor.sh`](scripts/doctor.sh)
- validation prompts: see [`references/cli-capabilities.md`](references/cli-capabilities.md)

## Use This Skill For

- running ERDA pipelines through `erda-cli`
- checking pipeline status, history, and logs
- diagnosing failed or stuck CI/CD flows
- explaining how pipeline and delivery commands fit together
- reviewing pipeline-oriented workflow assumptions when they affect execution
- diagnosing failed or stuck pipelines
- identifying missing branch, workspace, application, or task context

## Workflow

1. Confirm `erda-cli` availability and authentication first.
2. Identify the repository context, branch, workspace, org, project, and application.
3. Use the concrete `erda-cli pipeline` command set before falling back to generic advice.
4. Separate build creation, run history, status inspection, and log inspection as distinct troubleshooting steps.
5. If a static `pipeline.yml` is provided, only analyze it insofar as it affects actual CI/CD behavior.
6. When giving commands, prefer exact subcommands and flags over abstract descriptions.
7. When validating the skill itself, use the playbooks and validation prompts from the reference file.

## Review Priorities

- wrong branch or workspace assumptions
- missing pipeline context such as pipeline ID, task name, or application binding
- confusion between run creation, status inspection, history inspection, and log inspection
- delivery failures that are actually earlier build failures
- commands that skip authentication or repository cleanliness requirements

## References

- Shared CLI prerequisite: [`../../shared/references/erda-cli.md`](../../shared/references/erda-cli.md)
- Command guidance: [`references/cli-capabilities.md`](references/cli-capabilities.md)
- Templates: [`assets/templates/basic-pipeline.yml`](assets/templates/basic-pipeline.yml), [`assets/templates/build-release-deploy.yml`](assets/templates/build-release-deploy.yml)
