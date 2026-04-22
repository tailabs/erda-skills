# ERDA CI/CD Diagnostics

This reference captures the real-world failure modes that the skill must handle before giving advice.

## Minimal Diagnostic Sequence

Use this sequence by default when the user wants to run or troubleshoot a pipeline:

```bash
erda-cli whoami
git status --short
erda-cli pipeline history --branch <branch>
erda-cli -V pipeline run <file> --branch <branch>
```

If the user already has a pipeline ID:

```bash
erda-cli pipeline status -i <pipelineID>
erda-cli pipeline logs -i <pipelineID> --failed
```

## Dirty Workspace Handling

`erda-cli pipeline run` may fail with:

```text
Changes should be committed first
```

Skill behavior:

- treat this as a hard blocker for `pipeline run`
- explicitly tell the user that new pipeline content must be committed before execution
- require the user to commit the intended changes first
- do not present temporary clean clone as the default way to run new, uncommitted content

Recommended response pattern:

```bash
git status --short
git add .
git commit -m "..."
erda-cli pipeline run ./pipeline.yml
```

## Temporary Clean Clone Guidance

Prefer a normal clone over `git worktree` only for troubleshooting or reproduction.

Why:

- `erda-cli` may reject a worktree with `Current directory is not a local git repository`
- a plain clone behaves more like the repository layout the CLI expects

After cloning, check:

```bash
git remote -v
```

If `origin` points to a local filesystem path instead of the ERDA remote, correct it before relying on repository discovery.

## Context Inheritance

The CLI may depend on repository context such as `.erda.d/config` or equivalent project binding metadata.

Failure modes:

- the original repository works because parent-directory context exists
- a temporary clone loses that context and falls back to auto-discovery
- auto-discovery can then fail with permission errors

Skill behavior:

- explicitly tell the user to check whether `.erda.d/config` or equivalent context exists in the working directory or its parents
- if a temporary clone is used, warn that this context may need to be copied or recreated
- separate context discovery failure from actual pipeline execution failure

## Permission Diagnosis

Do not assume that successful login implies pipeline run permission.

Distinguish:

1. login/auth is valid
2. read access is valid
3. pipeline creation permission is valid
4. the branch is visible to ERDA

Examples:

- `erda-cli whoami` succeeds: authentication exists
- `erda-cli pipeline history --branch <branch>` succeeds: read path likely works
- `erda-cli -V pipeline run <file> --branch <branch>` returns `403 AccessDenied`: run permission or resolved context is still wrong
- `erda-cli pipeline history --branch <branch>` is empty and `pipeline run` reports an invalid branch or cannot fetch commit information: the branch may only exist locally

## Decision Tree

### Case 1: Context Discovery Failed

Typical symptoms:

- repository discovery fails
- project or application resolution fails
- temporary clone behaves differently from the original repository

Likely cause:

- missing `.erda.d/config`
- wrong `origin`
- wrong repository context

### Case 2: Context Is Correct But Run Still Fails

Typical symptoms:

- `whoami` succeeds
- history/status can read data
- `pipeline run` still returns `403 AccessDenied`

Likely cause:

- missing permission to create pipelines for that application or branch

### Case 3: Branch Exists Locally But Is Not Visible To ERDA

Typical symptoms:

- `git branch --show-current` shows the branch locally
- `erda-cli pipeline history --branch <branch>` returns nothing
- `erda-cli -V pipeline run <file> --branch <branch>` reports an invalid branch or cannot fetch commit information

Likely cause:

- the branch has not been pushed to the remote ERDA-visible repository yet

Recommended actions:

```bash
git push origin <branch>
erda-cli pipeline history --branch <branch>
erda-cli -V pipeline run <file> --branch <branch>
```

## Debug Defaults

When the user is troubleshooting a failing run, prefer `-V` by default:

```bash
erda-cli -V pipeline run <file> --branch <branch>
```

The verbose request and response details are often the shortest path to the real failure class.

## Standard Workflow

1. verify CLI availability
2. verify login with `whoami`
3. verify repository cleanliness with `git status --short`
4. if dirty, stop and require a commit before `pipeline run`
5. verify read access with `pipeline history`
6. if the branch is missing from history, check whether it has been pushed
7. if troubleshooting requires a reproduction environment, choose a safe clean-clone strategy
8. in a clean clone, verify `git remote -v`
9. verify `.erda.d/config` or equivalent context
10. run `erda-cli -V pipeline run ...`
11. classify the failure as context, branch visibility, permission, or pipeline-execution failure
