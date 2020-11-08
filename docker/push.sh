#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    if [[ -z "$1" ]]; then
        echo "RELEASE_VERSION argument is required" 1>&2
    fi
    echo "Example of use: ./push.sh 1.0.0-dev" 1>&2
    exit 1
fi

RELEASE_VERSION=$1

printf '\n'
printf '\n     Pushing containers to trendchaser4u DockerHub'
printf '\n'

docker push trendchaser4u/srec-video-conf:${RELEASE_VERSION}