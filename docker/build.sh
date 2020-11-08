#!/usr/bin/env bash

if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
    if [[ -z "$1" ]]; then
        echo "RELEASE_VERSION argument is required" 1>&2
    fi
    if [[ -z "$2" ]]; then
        echo "BRANCH_NAME argument is required" 1>&2
    fi
    if [[ -z "$3" ]]; then
        echo "ENVIRONMENT argument is required"
    fi
    echo "Example of use: ./build.sh 1.0.0 master dev" 1>&2
    exit 1
fi

BRANCH_NAME=$2
ENVIRONMENT=$3
CALL_BASE_HREF=/

printf '\n'
printf '\n     -------------------------------------------------------------'
printf '\n       Installing SREC VIDEO CONFERENCE app with the following arguments:'
printf '\n'
printf '\n          App container tag:  trendchaser4u/srec-video-conf:%s'  "${RELEASE_VERSION}"
printf '\n          Branch to build:  %s'  "${BRANCH_NAME}"
printf '\n          Environment to build:  %s'  "${ENVIRONMENT}"
printf '\n     -------------------------------------------------------------'
printf '\n'

if [ "$ENVIRONMENT" = "local" ]; then
    RELEASE_VERSION="$1-local"
    docker build -f docker/local.dockerfile -t trendchaser4u/srec-video-conf:${RELEASE_VERSION} --build-arg BASE_HREF=${CALL_BASE_HREF} .
elif [ "$ENVIRONMENT" = "dev" ]; then
    RELEASE_VERSION="$1-dev"
    docker build -f docker/dev.dockerfile -t trendchaser4u/srec-video-conf:${RELEASE_VERSION} --build-arg BRANCH_NAME=${BRANCH_NAME} --build-arg BASE_HREF=${CALL_BASE_HREF} .
elif [ "$ENVIRONMENT" = "prod" ]; then
    RELEASE_VERSION=$1
    docker build -f docker/prod.dockerfile -t trendchaser4u/srec-video-conf:${RELEASE_VERSION} --build-arg BRANCH_NAME=${BRANCH_NAME} --build-arg BASE_HREF=${CALL_BASE_HREF} .
elif [ "$ENVIRONMENT" = "stable" ]; then
    RELEASE_VERSION="$1-stable"
    docker build -f docker/stable.dockerfile -t trendchaser4u/srec-video-conf:${RELEASE_VERSION} .
else
    echo "ERR: not a valid environment. Environment must be one of local, dev, prod, stable."
fi