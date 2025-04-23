#!/bin/sh

docker buildx build --push --platform linux/amd64,linux/arm64 \
  --tag="apereo/fediz-client-webapp:2025" . \
  && echo "Built image successfully." \
  && docker images "apereo/fediz-client-webapp:2025"
