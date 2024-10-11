#!/bin/bash -l

if [[ -n "$RUNNER_DEBUG" ]]; then
  set -x
fi

if [[ ! -f Dockerfile ]]; then
  echo Using built-in Dockerfile.
  DOCKERFILE="-f /builder/Dockerfile"
else
  echo Using custom Dockerfile from project.
fi

export DOCKER_CONFIG=/build

if [[ "$BUILD_R_APP_PUSH" = "true" ]]; then
  trap "docker logout ghcr.io" EXIT
  echo ${GHCR_TOKEN} | docker login ghcr.io \
    -u ${GITHUB_REPOSITORY_OWNER} --password-stdin
else
  # otherwise the tag name is invalid
  GITHUB_REPOSITORY=${GITHUB_REPOSITORY:-null}
fi

if [[ -n "$CODECOV_TOKEN" ]]; then
  SECRET="--secret id=CODECOV_TOKEN"
fi

docker buildx build -t ghcr.io/${GITHUB_REPOSITORY}:latest \
  --target prod \
  ${DOCKERFILE} ${SECRET} \
  --label "org.opencontainers.image.source=${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}" \
  --platform linux/amd64 \
  --build-arg GITHUB_SHA=${GITHUB_SHA} \
  --build-arg GITHUB_REPOSITORY=${GITHUB_REPOSITORY} \
  --build-arg GITHUB_REF_NAME=${GITHUB_REF_NAME} .

if [[ "$BUILD_R_APP_PUSH" = "true" ]]; then
  docker push ghcr.io/${GITHUB_REPOSITORY}:latest
fi
