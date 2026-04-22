# `dice.yml` Field Index

This index is summarized from the ERDA `dice.yml` parser structures.

## Root Fields

- `version`
- `meta`
- `envs`
- `services`
- `jobs`
- `addons`
- `environments`
- `values`

## `environments.<name>`

Each environment object may contain:

- `envs`
- `services`
- `addons`

## `addons.<name>`

Supported fields:

- `plan`
- `as`
- `options`
- `actions`
- `image`

## `jobs.<name>`

Supported fields:

- `image`
- `cmd`
- `envs`
- `resources`
- `labels`
- `binds`
- `volumes`
- `init`
- `hosts`

## `services.<name>`

Supported fields:

- `image`
- `image_username`
- `image_password`
- `cmd`
- `ports`
- `envs`
- `hosts`
- `resources`
- `labels`
- `annotations`
- `binds`
- `volumes`
- `deployments`
- `depends_on`
- `expose`
- `health_check`
- `sidecars`
- `init`
- `mesh_enable`
- `traffic_security`
- `endpoints`
- `k8s_snippet`

## `services.<name>.ports[]`

Supported fields:

- `port`
- `protocol`
- `l4_protocol`
- `expose`
- `default`

The parser also accepts a shorthand integer port entry.

## `services.<name>.resources`

Supported fields:

- `cpu`
- `mem`
- `max_cpu`
- `max_mem`
- `disk`
- `network`
- `emptydir_size`
- `ephemeral_storage_size`

## `services.<name>.deployments`

Supported fields:

- `replicas`
- `policies`
- `labels`
- `workload`
- `selectors`
- `mode`

## `services.<name>.health_check`

Supported blocks:

- `http`
- `exec`

### `health_check.http`

- `port`
- `path`
- `duration`

Notes:

- `duration` is an integer field.
- write it as a plain number such as `90`, not as a duration string such as `90s`.

### `health_check.exec`

- `cmd`
- `duration`

Notes:

- `duration` is an integer field.
- write it as a plain number such as `90`, not as a duration string such as `90s`.

## `services.<name>.sidecars.<name>`

Supported fields:

- `image`
- `cmd`
- `envs`
- `shared_dir`
- `resources`

## `services.<name>.init.<name>`

Supported fields:

- `image`
- `shared_dir`
- `cmd`
- `resources`

## `services.<name>.volumes[]`

Supported object fields:

- `id`
- `storage`
- `path`
- `type`
- `size`
- `targetPath`
- `readOnly`
- `snapshot`

Also note:

- the parser accepts shorthand string volume syntax

### `snapshot`

- `maxHistory`

## `services.<name>.endpoints[]`

Supported fields:

- `domain`
- `path`
- `backend_path`
- `policies`

### `endpoints[].policies`

Supported fields:

- `cors`
- `rate_limit`

## `services.<name>.traffic_security`

Supported fields:

- `main`
- `sidecar`

## `services.<name>.k8s_snippet`

Supported blocks:

- `container`
- `workload`

### `k8s_snippet.container`

Supported fields include:

- `workingDir`
- `envFrom`
- `env`
- `livenessProbe`
- `readinessProbe`
- `startupProbe`
- `lifecycle`
- `terminationMessagePath`
- `terminationMessagePolicy`
- `imagePullPolicy`
- `securityContext`
- `stdin`
- `stdinOnce`
- `tty`

### `k8s_snippet.workload.deployment`

Supported fields:

- `minReadySeconds`
- `strategy`

## `values`

`values` is keyed by workspace:

- `development`
- `test`
- `staging`
- `production`

Each workspace value is a string map.

## Practical Notes

- `services` is the main deployment surface for application services.
- `jobs` is separate from `services` and has a smaller field surface.
- `ports` supports both integer shorthand and explicit object form.
- `volumes` supports both shorthand string form and explicit object form.
- `environments` and `values` are both part of environment-aware configuration, but they are different layers in the spec.
