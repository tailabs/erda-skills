# Semantic Notes

This reference summarizes important parser and orchestration behavior that goes beyond field names.

Use this file when the user asks:

- what happens after environment overlays are applied
- whether a spec is only structurally valid or also likely semantically valid
- how pipeline version upgrade works
- how refs, params, secrets, namespaces, and default dependencies behave
- why a spec shape looks valid but still behaves differently than expected

## `dice.yml` Semantic Notes

## Environment Overlay Is A Merge Layer

`environments.<workspace>` is not a separate standalone spec. It is merged into the base object.

High-value implications:

- root `envs` can be overridden by environment `envs`
- environment service objects can override base service fields
- missing services can be introduced by the environment overlay
- environment addons replace the addon set rather than incrementally patching individual addon fields

Fields explicitly merged for services include:

- `image`
- `cmd`
- `ports`
- `envs`
- `hosts`
- `binds`
- `volumes`
- `depends_on`
- `expose`
- `resources`
- `deployments`
- `health_check`

Practical rule:

- if a question is about final workspace shape, answer from the merged result, not only from the base `services` block.

## `expose` Has Compatibility Behavior

If a service uses both `expose` and `ports`, compatibility handling marks the first port as exposed.

Practical rule:

- when reviewing older specs, treat `expose` as affecting port exposure semantics even if the modern intent is expressed in `ports[].expose`.

## Basic Validation Is Stronger Than Field Existence

The parser-side validation checks more than field names.

Common rules include:

- at least one of `services` or `jobs` must exist
- service resources must define usable CPU and memory
- `max_cpu` cannot be smaller than `cpu`
- `max_mem` cannot be smaller than `mem`
- port values and `expose` values must be positive
- volumes and bind paths must be absolute in the expected positions
- deployment `replicas` cannot be negative
- deployment `policies` is limited to supported values
- addon `plan` cannot be empty
- `traffic_security.mode` is effectively restricted to empty or `https`
- endpoint domains and paths have format constraints

Practical rule:

- “field exists” is not enough. For review tasks, separate structural support from parser-side validation expectations.

## Health Check Duration Is Numeric

`health_check.http.duration` and `health_check.exec.duration` are numeric fields in the ERDA `dice.yml` structures.

High-value implications:

- write duration as an integer such as `90`
- do not write duration as a human-readable string such as `90s`
- a string duration can pass a casual YAML review but still fail when the deploy side unmarshals the spec

Practical rule:

- if deployment reports an unmarshal error around `health_check.*.duration`, check for string-style duration values first.

## `pipeline.yml` Semantic Notes

## Version `1.0` Is Upgraded Into `1.1`

The parser treats legacy `1.0` or `1` content as upgradeable input and converts it into `1.1` structure.

High-value implications:

- `version: 1.1` is the canonical shape to author now
- `1.0` content can still be read, but the effective structure is the upgraded form
- some platform-injected placeholders are simplified away during upgrade

Practical rule:

- when users ask for authoring guidance, answer in `1.1` form even if they currently hold a `1.0` file.

## Stage Defaults Matter

If an action does not declare `needs`, the parser gives it dependencies on all actions from previous stages.

If an action does not declare `needNamespaces`, the parser gives it access to all namespaces produced by previous stages.

Practical rule:

- cross-stage ordering is not only visual. A stage boundary changes default dependency and ref visibility behavior.

## Action Alias And Namespace Rules Matter

Each action gets:

- a default alias equal to its action type when alias is omitted
- a default namespace that includes its alias

Aliases and namespaces must not collide.

Practical rule:

- duplicate aliases are a real spec problem, not just a style problem.

## Refs Are Validated Against Stage Visibility

The parser resolves refs against aliases and namespaces that are already available.

Important consequences:

- refs are not purely textual substitutions
- output refs and directory refs are stage-aware
- later stages can consume earlier outputs by default, but same-stage assumptions need care

Practical rule:

- if a user asks why `${...}` or `${{ outputs... }}` is failing, inspect alias, stage ordering, and output availability before blaming syntax alone.

## Pipeline Params Are Replaced Textually

Pipeline-level `params` are substituted into the YAML text before the final structure is unmarshaled.

High-value implications:

- value shape after replacement matters
- strings, numbers, and booleans can affect the resulting YAML meaning
- random parameter helpers are resolved during replacement

Practical rule:

- when advising on `params`, consider the resulting YAML content, not only the declared param type.

## Secret Rendering Has Format Rules

Secret rendering supports `((secret_name))` style placeholders and validates their format.

Important consequences:

- malformed secret placeholders are parser-visible problems
- missing secrets remain missing and produce errors
- config-style placeholders are also handled through secret rendering

Practical rule:

- if the user asks why a secret did not resolve, check placeholder format first, then key existence.

## Environment Variable Keys Are Validated

Pipeline `envs` keys must match a conventional environment-variable pattern.

Practical rule:

- invalid env keys are not only style issues; they become parser errors.

## Snippet Params Are Typed Narrowly

Snippet rendering applies default values, required checks, and restrictive value-type handling.

High-value implications:

- missing required params are rejected
- default values can be injected automatically
- snippet param values are expected to remain scalar-like in the supported flow

Practical rule:

- when a snippet pipeline behaves unexpectedly, inspect param defaults and param value types before inspecting downstream actions.
