# Runtime Operations

`erda-runtime` is intentionally narrower than `erda-cicd`. It relies on `erda-cli` for live operations and should not pretend runtime state can be inferred from static files alone.

## Use This Skill For

- runtime status checks
- runtime list queries
- deployment inspection
- log inspection
- instance list queries
- restart and scale guidance
- safe troubleshooting sequencing

## Runtime Command Playbooks

## From A Pipeline Run To Runtime Scope

When a runtime question comes immediately after a pipeline run, recover the runtime scope in this order:

1. read `runtimeID` directly from the pipeline watch or final output when available
2. if `runtimeID` is not available, use application and workspace context with `erda-cli runtime list`

Example:

```bash
erda-cli runtime list --workspace TEST
erda-cli runtime status --runtime-id 10001
```

### List Runtimes

Use when the user wants to discover the runtime or identify the current workspace target:

```bash
erda-cli runtime list
erda-cli runtime list --workspace DEV
erda-cli runtime list --runtime-id 10001
```

### Inspect Runtime Status

Use when the user wants the current runtime state for a workspace or exact runtime:

```bash
erda-cli runtime status
erda-cli runtime status --workspace TEST
erda-cli runtime status --runtime-id 10001
```

### Read Runtime Logs

Use when the user needs service-level or instance-level logs:

```bash
erda-cli runtime logs
erda-cli runtime logs --service web
erda-cli runtime logs --service web --instance pod-0 --watch
erda-cli runtime logs --runtime-id 10001 --tail 500
```

### Inspect Runtime Instances

Use when the user needs pod/container level visibility:

```bash
erda-cli runtime instance list
erda-cli runtime instance list --service web
erda-cli runtime instance list --service web --all
erda-cli runtime instance logs --service web --instance pod-0 --watch
```

## Operating Rule

Always verify `erda-cli` availability and authentication first. If the user wants commands, prefer concrete commands over abstract advice.

## Troubleshooting Order

1. identify org, project, app, environment, and runtime scope
2. inspect status and latest deployment state
3. inspect service logs and failing components
4. inspect resource pressure and configuration drift
5. only then suggest restart, redeploy, or scale actions

## Current State Versus Deployment-Time State

`runtime status` only describes the current state.

If the user asks "was there any issue during deployment?" or "did anything go wrong before it became healthy?", do not conclude from `runtime status: Healthy` alone.

Required behavior:

- inspect pipeline logs for deployment-time failures or retries
- inspect runtime instance list and runtime logs for process-level symptoms
- treat current healthy state and deployment-time stability as separate questions

## Validation Prompts

Use these prompts to verify the skill behaves correctly after installation:

1. "I want to inspect the runtime status of the current application in the TEST environment. Which erda-cli command should I use?"
2. "A service is failing. Should I check runtime status or logs first? Give me the correct troubleshooting order."
3. "I need to view and follow the logs of a specific instance in the web service. What erda-cli command should I run?"
