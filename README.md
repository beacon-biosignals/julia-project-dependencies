# Julia Project Dependencies

Examines a Julia project returns details about the dependencies. Primarily this action is used to detect and alert developer about the use of unpublished dependencies.

## Example

```yaml
---
jobs:
  example:
    permissions: {}
    runs-on: ubuntu-latest
    steps:
      - uses: julia-actions/setup-julia@v2
        with:
          version: "1.10"
      - uses: beacon-biosignals/julia-project-dependencies@v1
        id: deps
      - name: Fail if unpublished dependencies
        if: ${{ steps.deps.outputs.num-unpublished-dependencies > 0 }}
        run: |
          echo "All Julia dependencies must reference published packages before proceeding" >&2
          exit 1
```

## Inputs

| Name                 | Description | Required | Example |
|:---------------------|:------------|:---------|:--------|
| `project`            | The Julia project directory. Defaults to `.` | No | `./Package.jl` |

## Outputs

| Name                           | Description | Example |
|:-------------------------------|:------------|:--------|
| `direct-dependencies`          | List of newline separated Julia package names which this project defines under the `deps` section of the `Project.toml`. | <pre><code>Example&#10;Pkg</code></pre> |
| `num-direct-dependencies`      | Number of Julia packages listed under the `deps` section of the `Project.toml`. | `2` |
| `unpublished-dependencies`     | List of newline separated Julia package names used by this project which are not published. | <pre><code>Example</code></pre> |
| `num-unpublished-dependencies` | Number of Julia packages used by this project which are not published. | `1` |

## Permissions

No [job permissions](https://docs.github.com/en/actions/using-jobs/assigning-permissions-to-jobs) are required to run this action.
