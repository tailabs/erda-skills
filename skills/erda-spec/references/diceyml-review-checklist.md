# `dice.yml` Review Checklist

Use this checklist when reviewing an ERDA `dice.yml`.

## Review Order

1. confirm the file has a valid top-level shape
2. inspect service and job definitions
3. inspect resource, port, volume, and deployment settings
4. inspect addon and environment overlay behavior
5. inspect service exposure and endpoint behavior
6. inspect cross-file expectations with `release` or `pipeline.yml`

## Top-Level Shape

Check:

- whether at least one of `services` or `jobs` exists
- whether `version` is present if the surrounding convention expects it
- whether `environments` and `values` are used intentionally rather than mixed casually

Common findings:

- empty `services` and empty `jobs`
- environment-specific content placed directly at root when it should be under `environments`

## Service And Job Definitions

Check:

- whether each service has a coherent `image`, `cmd`, `envs`, and `resources` shape
- whether each job uses the smaller job field surface instead of service-only fields
- whether service names look stable enough to be referenced from release image mappings

Common findings:

- service naming that will not match `release.params.image`
- job blocks carrying service assumptions

## Resources

Check:

- whether CPU and memory are actually set to usable values
- whether `max_cpu` is not smaller than `cpu`
- whether `max_mem` is not smaller than `mem`
- whether disk and ephemeral storage fields are non-negative
- whether network mode, if specified, uses a supported value

Common findings:

- zero or missing CPU or memory
- `max_*` values smaller than base values
- invalid network mode

## Ports And Exposure

Check:

- whether every declared port is positive
- whether `ports` uses either shorthand or explicit object form consistently enough to stay readable
- whether `ports[].expose` and legacy `expose` usage are consistent with intent
- whether `default` is used intentionally when multiple ports exist

Common findings:

- invalid port numbers
- legacy `expose` hiding the real exposure intent
- service exposure relying on the wrong port

## Volumes And Binds

Check:

- whether volume object form uses valid absolute paths where required
- whether bind strings use valid host path, container path, and access mode
- whether shorthand and object form are mixed in a way that hurts maintainability

Common findings:

- non-absolute bind or volume paths
- invalid bind mode

## Deployments

Check:

- whether `replicas` is non-negative
- whether `policies` is one of the supported values
- whether selectors and labels are intentional
- whether workload-specific settings fit the intended deployment model

Common findings:

- unsupported deployment policy
- negative replica count

## Health Checks

Check:

- whether the chosen check type matches the service behavior
- whether HTTP check ports and paths are valid
- whether exec check commands and durations are plausible
- whether `health_check.http.duration` and `health_check.exec.duration` are plain integers rather than strings

Common findings:

- HTTP path missing leading slash
- check attached to the wrong port or command
- duration written as `90s` instead of `90`

## Addons

Check:

- whether every addon declares a non-empty `plan`
- whether addon options align with the intended dependency behavior
- whether environment-specific addon definitions are replacing root addons intentionally

Common findings:

- empty addon plan
- accidental replacement of addon config through environment overlay

## Endpoints And Traffic Security

Check:

- whether endpoint domains are valid
- whether endpoint paths start with `/` when specified
- whether `traffic_security.mode` stays within supported behavior
- whether endpoint policies are attached at the correct place

Common findings:

- invalid endpoint domain syntax
- endpoint path without leading slash
- unsupported traffic security mode

## Environment Overlay Behavior

Check:

- whether reviewers are reasoning from the merged workspace result rather than only root config
- whether environment service overrides are partial overrides, not accidental rewrites
- whether missing services introduced under an environment are intentional
- whether addon replacement behavior is understood

Common findings:

- assuming `environments.<workspace>` is independent rather than merged
- forgetting that environment addon definitions replace the addon set

## Cross-File Checks

Check:

- whether service names align with `release.params.image` keys in `pipeline.yml`
- whether the deployment expectation implied by `pipeline.yml` matches the actual service and addon structure
- whether workspace-specific `dice_*_yml` files and root `dice.yml` are consistent if both are used

Common findings:

- service/image mapping mismatch between `dice.yml` and `release`
- pipeline assumes a deployable service that does not exist in `dice.yml`

## Review Output Format

When writing review findings, prefer grouping by:

- structural support problems
- parser-side validation risks
- environment-merge risks
- release/deploy integration risks
