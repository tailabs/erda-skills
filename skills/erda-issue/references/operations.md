# ERDA Issue Operations

This reference captures the skill-local workflow knowledge for:

- creating ERDA issues (`erda-cli issue create`)
- proposing next state transitions from `erda-cli issue schema` (`next`, plan-only)
- applying explicit state transitions (`update`, user-confirmed)
- binding parent/child issues (`erda-cli issue bind`, user-confirmed)

## Create Issue (schema-driven, user-confirmed apply)

### Plan-only (no state change)
1. Verify auth with `erda-cli whoami`.
2. Determine issue type: `bug` / `task` / `requirement`.
3. Retrieve schema contract:

```bash
erda-cli issue schema --type <type>
```

4. Ask the user for any required fields missing from the request.
5. Generate an inline JSON payload (`issue.json`) using schema-derived fields.
6. Show a summary back to the user (title/body/type and any key fields that affect workflow and ownership).
7. If binding is requested in the same conversation, also show:
   - parent issue id
   - relation mapping (`inclusion` vs `connection`)
   - the child issue id(s) that will be created
8. Ask for confirmation before any apply step.

### Confirm gate
- Only proceed when the user explicitly confirms the payload.

### Apply
1. Create the issue:

```bash
erda-cli issue create --json '<inline-json>'
```

2. If binding is part of this flow:
   - require a second explicit confirmation before running bind (unless the user clearly asked for “create and bind now” in the same message).
   - then run:

```bash
erda-cli issue bind --parent <parent-id> --children <child-id> --type inclusion|connection
```

## Next State Proposal (plan-only)

### Inputs
- `issue-id` (required)
- optional `type` (recommended; drives schema lookup)

### Plan-only steps
1. Find current state of the issue:

```bash
erda-cli issue list --type <type> --wide --json
```

2. Locate the provided `issue-id` in the output.
3. Retrieve the schema transitions/ordering:

```bash
erda-cli issue schema --type <type>
```

4. Compute the schema-defined next state for the current state.
5. Output:
   - current state name
   - proposed next state name
   - “derived from issue schema”
6. Ask whether the user wants to apply the update.

### Stop condition (no wrap-around)
- If the current state is the last state in the schema-defined ordering, `next` must fail and instruct the user to use:

```bash
erda-cli issue update <issue-id> --state <target-state-name>
```

## Update Issue (explicit target, user-confirmed apply)

### Inputs
- `issue-id` (required)
- target state specified as either:
  - `--state <state-name>`
  - or `--state-id <state-id>`

### Plan-only steps
1. Resolve the user target (name or id).
2. Optionally validate existence under `erda-cli issue schema --type <type>` when type is known.
3. Echo:
   - issue-id
   - target state name/id
4. Ask for confirmation before apply.

### Apply
Run exactly one of the following after confirmation:

```bash
erda-cli issue update <issue-id> --state <state-name>
```

or

```bash
erda-cli issue update <issue-id> --state-id <state-id>
```

## Bind Parent/Child (user-confirmed apply)

### Inputs
- `--parent <parent-id>` (required)
- `--children <child-ids>` (required; comma-separated ids)
- relation mapping:
  - `inclusion` for “包含 / inclusion”
  - `connection` for “关联 / associated”

### Plan-only steps
1. If bind type is not explicitly provided, infer from natural-language keywords:
   - user says “关联/associated” -> `connection`
   - default -> `inclusion`
2. Echo:
   - parent id
   - child ids
   - relation type (`inclusion` vs `connection`)
3. Ask for confirmation before apply.

### Apply
```bash
erda-cli issue bind --parent <parent-id> --children <child-ids> --type inclusion|connection
```

## Validation Prompts (post-install behavior checks)

1. Create a TASK issue with schema-driven fields:
   - “Create a TASK issue for this project. Use `type=task`. Ask me for any required fields, then show the JSON payload and ask for confirmation.”

2. Next state proposal must be plan-only:
   - “I have issue id `12345`. Tell me the current state and propose the next state based on `issue schema`. Do not update yet—ask me to confirm.”

3. Update must require confirmation:
   - “Update issue `12345` to state `Resolved` (by name). Ask me to confirm before running the update.”

4. Bind inclusion inferred from wording:
   - “Bind new TASK issue to parent REQUIREMENT issue `2222` as 包含 (inclusion). Ask for confirmation before binding.”

5. Bind connection inferred from wording:
   - “Bind children `101,102` to parent `18` as 关联 (connection). Ask for confirmation before binding.”

