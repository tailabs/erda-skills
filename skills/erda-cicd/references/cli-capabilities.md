# erda-cli CI/CD Capabilities

This skill should align with the real `erda-cli` CI/CD command surface implemented by the ERDA CLI.

## Pipeline Commands

The CLI exposes a `pipeline` command group focused on execution and inspection:

- `erda-cli pipeline run <path-to/pipeline.yml>`
- `erda-cli pipeline status`
- `erda-cli pipeline status -i <pipelineID>`
- `erda-cli pipeline history`
- `erda-cli pipeline logs -i <pipelineID>`

## Operational Behaviors

- `pipeline run` requires a clean git workspace and resolves branch/application context from the current repository
- `pipeline status` can infer the latest pipeline on the current branch when no pipeline ID is given
- `pipeline history` filters by branch, sources, statuses, and yml names
- `pipeline logs` supports `--task-id`, `--task`, `--all`, `--failed`, `--running`, `--watch`, `--tail`, `--stream`, `--json`, and `--raw`

## Typical Command Playbooks

### Create A Pipeline Run

Use when the user wants to trigger a pipeline from the current repository:

```bash
erda-cli pipeline run pipeline.yml
erda-cli pipeline run .erda/pipelines/build.yml --branch feature/my-branch
erda-cli pipeline run pipeline.yml --watch
```

Notes:

- the current directory must be a git repository
- the workspace must be clean before `pipeline run`
- when branch is omitted, the current git branch is used

### Check Current Pipeline State

Use when the user wants the newest pipeline on the current branch or a specific pipeline:

```bash
erda-cli pipeline status
erda-cli pipeline status --branch develop
erda-cli pipeline status -i 123456
erda-cli pipeline status -i 123456 --watch
```

Notes:

- `pipeline status` can infer the latest pipeline when `-i` is omitted
- `--watch` is the right choice when the user is following an active build

### Inspect Historical Runs

Use when the user wants to compare runs or find a failed build from the past:

```bash
erda-cli pipeline history
erda-cli pipeline history --branch main --statuses Failed
erda-cli pipeline history --page 2 --page-size 10
erda-cli pipeline history --yml-names pipeline.yml
```

### Read Task Logs

Use when the user has a failing pipeline or needs output from a concrete task:

```bash
erda-cli pipeline logs -i 123456
erda-cli pipeline logs -i 123456 --task build
erda-cli pipeline logs -i 123456 --task-id 987654
erda-cli pipeline logs -i 123456 --failed --watch
erda-cli pipeline logs -i 123456 --all --tail 500
```

Notes:

- `--task` and `--task-id` are best when the failing task is already known
- `--failed` is the fastest path when the user only wants failed task logs
- `--raw` should only be used for a single task selection

## Troubleshooting Sequence

When the user says "the pipeline failed" or "CI/CD is stuck", default to this order:

1. confirm repo context, branch, org, project, and application
2. locate the run with `pipeline status` or `pipeline history`
3. inspect failed or running tasks with `pipeline logs`
4. separate pipeline execution failure from downstream delivery or runtime failure

## Validation Prompts

Use these prompts to verify the skill behaves correctly after installation:

1. "I want to trigger a pipeline from the current repository and keep watching its status. Which erda-cli commands should I use?"
2. "Help me troubleshoot a failed pipeline. Give me the correct sequence using status, history, and logs."
3. "I only know the pipeline ID and want to inspect the failed task logs. How should I do that with erda-cli?"

## Skill Guidance

- Prefer the command that matches the user’s task exactly instead of collapsing everything into “check the pipeline”.
- Distinguish between creating a run, checking status, looking at historical runs, and reading task logs.
- If a deployment failed, determine whether the failure happened in pipeline execution or later in runtime behavior.
- If the user asks about static `pipeline.yml`, keep the answer tied to how it affects actual `erda-cli` execution paths.

## Samples Used In This Repository

- `../assets/templates/basic-pipeline.yml`
- `../assets/templates/build-release-deploy.yml`
