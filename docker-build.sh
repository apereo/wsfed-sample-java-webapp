#!/bin/sh

docker build --tag="apereo/fediz-client-webapp" . \
  && echo "Built image successfully." \
  && docker images "apereo/fediz-client-webapp"

docker_user="$1"
docker_psw="$2"

if [ -n "${docker_user}" ]; then
  echo "$docker_psw" | docker login --username "$docker_user" --password-stdin
  echo "Pushing docker image: apereo/fediz-client-webapp"
  docker push apereo/fediz-client-webapp \
    && echo "Pushed apereo/fediz-client-webapp successfully.";
fi