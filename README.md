## Build and publish an R app container

> This project is experimental!

Package up an R script into a Docker container and publish it in the
GitHub Container Registry.

## Usage

Example workflow:

```yaml
name: docker-build.yaml
on:
  push:
  workflow_dispatch:

jobs:
  docker-build:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v4
    - name: Build and push app
      uses: gaborcsardi/build-r-app@main
      with:
        codecov-token: ${{ secrets.CODECOV_TOKEN }}
        ghcr-token: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

* `codecov-token`: deployment token for https://codecov.io.
* `ghcr-token`: token to push to the GitHub Container Registry (GHCR).
* `push`: whether to push the built image, defaults to `true`.

## R project setup

### Dependencies

Declare dependencies in a `DESCRIPTION` file. Also add the `Package` and
`Version` fields. Example:
```
Package: projectname
Version: 1.0.0
Imports:
    cli,
    dplyr
Suggests:
    covr,
    testthat
```

Use `Imports:` for the packages that you use in your app. Use `Suggests:`
for packages that you use in your tests.

### Tests

You can add [testthat](https://testthat.r-lib.org/) tests into the `tests`
directory. If you add tests, then add the testthat and covr packages as
dependencies under `Suggests` in `DESCRIPTION`.

If you have a `tests` directory, every build runs the tests and also
test coverage with covr, automatically. If the tests fail, the build fails
and no image will be deployed.

### Test coverage

If you have tests, then every build automatically runs the test coverage
using the covr package.

## Example project

See https://github.com/r-hub/cran-metadata for a fully functional example
project.

## Related

* [`run-r-app` action](https://github.com/gaborcsardi/run-r-app) to
  the container on GitHub Actions

## License

MIT (c) Posit Software, PBC, 2024
