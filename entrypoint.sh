#!/bin/bash -l

if [[ ! -f Dockerfile ]]; then
  echo Using built-in Dockerfile.
  cp /builder/Dockerfile .
else
  echo Using custom Dockerfile from project.
fi

if [[ -n "$BUILD_R_APP_PUSH" ]]; then
  trap "docker logout ghcr.io" EXIT
  echo ${GHCR_TOKEN} | docker login ghcr.io \
    -u ${GITHUB_REPOSITORY_OWNER} --password-stdin
fi

if [[ -n "$CODECOV_TOKEN" ]]; then
  SECRET="--secret id=CODECOV_TOKEN"
fi

docker buildx build -t ghcr.io/${GITHUB_REPOSITORY}:latest \
  --target runtime \
  ${SECRET} \
  --platform linux/amd64 \
  --build-arg GITHUB_SHA=${GITHUB_SHA} \
  --build-arg GITHUB_REPOSITORY=${GITHUB_REPOSITORY} \
  --build-arg GITHUB_REF_NAME=${GITHUB_REF_NAME} .

if [[ -n "$BUILD_R_APP_PUSH" ]]; then
  docker push ghcr.io/${GITHUB_REPOSITORY}:latest
fi
